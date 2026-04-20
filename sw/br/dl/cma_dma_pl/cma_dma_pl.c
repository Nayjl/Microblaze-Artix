#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/fs.h>
#include <linux/uaccess.h>
#include <linux/slab.h>
#include <linux/mm.h>
#include <linux/device.h>
#include <linux/ioctl.h>
//#include <asm/phys.h>
#include <asm/io.h>
// #include<linux/proc_fs.h>
#include <linux/dma-mapping.h>

// For device tree
// #include <linux/of.h>
// #include <linux/of_reserved_mem.h>

#define DEVICE_NAME "cma_dma_pl"
#define CLASS_NAME "allocContinuousMemoryDMAPL"

// Определение команд IOCTL
#define CMA_ALLOC _IOW('m', 1, size_t)
#define CMA_FREE  _IO('m', 2)
#define CMA_GET_PHYS_ADDR _IOR('m', 3, unsigned long)
#define CMA_GET_SIZE_ALLOC _IOR('m', 4, size_t)




static int majorNumber;
static struct class *memory_class;
static struct device *memory_device;

static void *dma_buffer = NULL; // Указатель на DMA-буфер
static dma_addr_t dma_handle;   // Физический адрес DMA
static size_t allocated_size = 0;




static int dev_open(struct inode *inodep, struct file *filep) {
    printk(KERN_INFO "cma_dma_pl: Device open\n");
    return 0;
}

static int dev_release(struct inode *inodep, struct file *filep) {
    printk(KERN_INFO "cma_dma_pl: Device close\n");
    return 0;
}


static int dev_mmap(struct file *filep, struct vm_area_struct *vma) {
    size_t size = 0;
    unsigned long number_page = 0;
    pgprot_t prot;

    if (vma->vm_pgoff == 0) {
        number_page = dma_handle >> PAGE_SHIFT;
    } else {
        number_page = vma->vm_pgoff;
    }
    
    size = vma->vm_end - vma->vm_start;
    if (size > allocated_size) {
        printk(KERN_ERR "cma_dma_pl: Error displaying the allocated memory, the displayed memory is larger than the allocated one\n");
        return -EINVAL;
    }
    
    printk(KERN_INFO "cma_dma_pl: Size alloc foring mapping in bytes = %zu\n", size);
    prot = pgprot_noncached(vma->vm_page_prot);

    if (remap_pfn_range(vma, vma->vm_start, number_page, size, prot)) {
        printk(KERN_ERR "cma_dma_pl: Error see memmory\n");
        return -EAGAIN;
    }

    printk(KERN_INFO "cma_dma_pl: Page number %lu\n", number_page);
    return 0;
}




static long dev_ioctl(struct file *filep, unsigned int cmd, unsigned long arg) {
    switch (cmd) {
        case CMA_ALLOC: {
            size_t size;
            if (copy_from_user(&size, (void __user *)arg, sizeof(size))) {
                printk(KERN_WARNING "cma_dma_pl: WARNING Couldn't get a request from the user\n", size);
                return -EFAULT;
            }
            if (dma_buffer) {
                printk(KERN_WARNING "cma_dma_pl: WARNING The memory was allocated even earlier\n", size);
                dma_free_coherent(memory_device, allocated_size, dma_buffer, dma_handle);
            }
            if ((size % PAGE_SIZE) != 0) {
                printk(KERN_WARNING "cma_dma_pl: WARNING Memory non page\n", size);
                return -ENOMEM;
            }
            dma_buffer = dma_alloc_coherent(memory_device, size, &dma_handle, GFP_KERNEL);
            if (!dma_buffer) {
                printk(KERN_ALERT "cma_dma_pl: ALERT Error alloc memory\n");
                return -ENOMEM;
            }
            allocated_size = size;
            printk(KERN_INFO "cma_dma_pl: Alloc %zu byte DMA-memory\n", allocated_size);
            break;
        }
        case CMA_FREE: {
            if (dma_buffer) {
                dma_free_coherent(memory_device, allocated_size, dma_buffer, dma_handle);
                dma_buffer = NULL;
                allocated_size = 0;
                printk(KERN_INFO "cma_dma_pl: CMA memory is released\n");
            } else {
                printk(KERN_WARNING "cma_dma_pl: WARNING Clearing error, memory has not been allocated\n");
            }
            break;
        }
        case CMA_GET_PHYS_ADDR: {
            if (!dma_buffer) {
                printk(KERN_WARNING "cma_dma_pl: WARNING Error when receiving the buffer address, memory is not allocated\n");
                return -EINVAL;
            }
            if (copy_to_user((void __user *)arg, &dma_handle, sizeof(dma_handle))) {
                printk(KERN_WARNING "cma_dma_pl: WARNING Error when transmitting the buffer address to the user: 0x%lx\n", (unsigned long)dma_handle);
                return -EFAULT;
            }
            printk(KERN_INFO "cma_dma_pl: Return physical address: 0x%lx\n", (unsigned long)dma_handle);
            break;
        }
        case CMA_GET_SIZE_ALLOC: {
            if (!dma_buffer) {
                printk(KERN_WARNING "cma_dma_pl: WARNING Error when getting the buffer size, memory is not allocated\n");
                return -ENOMEM;
            }
            if (copy_to_user((void __user *)arg, &allocated_size, sizeof(allocated_size))) {
                printk(KERN_ALERT "cma_dma_pl: ALERT Error getting the buffer size to the user: %zu\n", allocated_size);
                return -EFAULT;
            }
            printk(KERN_INFO "cma_dma_pl: The buffer size has been transferred to the user: %zu\n", allocated_size);
            break;
        }
        default:
            return -EINVAL;
    }
    return 0;
}


static const struct file_operations fops = {
    .owner = THIS_MODULE,
    .open = dev_open,
    .release = dev_release,
    .unlocked_ioctl = dev_ioctl,
    .mmap = dev_mmap
};



static int kmem_init(void) {

    unsigned int remains;

    printk(KERN_INFO "cma_dma_pl: Initialization driver\n");

    // Регистрируем символьное устройство
    majorNumber = register_chrdev(0, DEVICE_NAME, &fops);
    if (majorNumber < 0) {
        printk(KERN_ALERT "cma_dma_pl: ALERT Device registration error\n");
        return majorNumber;
    }
    printk(KERN_INFO "cma_dma_pl: Registrate with major number %d\n", majorNumber);

    // Создаем класс устройства
    memory_class = class_create(CLASS_NAME);
    // memory_class = class_create(THIS_MODULE, CLASS_NAME);
    if (IS_ERR(memory_class)) {
        unregister_chrdev(majorNumber, DEVICE_NAME);
        printk(KERN_ALERT "cma_dma_pl: ALERT Error creating the device class\n");
        return PTR_ERR(memory_class);
    }
    printk(KERN_INFO "cma_dma_pl: Class device create\n");

    // Создаем устройство
    memory_device = device_create(memory_class, NULL, MKDEV(majorNumber, 0), NULL, DEVICE_NAME);
    if (IS_ERR(memory_device)) {
        class_destroy(memory_class);
        unregister_chrdev(majorNumber, DEVICE_NAME);
        printk(KERN_ALERT "cma_dma_pl: ALERT Device creation error\n");
        return PTR_ERR(memory_device);
    }
    printk(KERN_INFO "cma_dma_pl: Device create\n");
    
    return 0;
}


static void __exit kmem_exit(void) {
    if (dma_buffer) {
        dma_free_coherent(memory_device, allocated_size, dma_buffer, dma_handle);
    }
    device_destroy(memory_class, MKDEV(majorNumber, 0));
    class_unregister(memory_class);
    class_destroy(memory_class);
    unregister_chrdev(majorNumber, DEVICE_NAME);

    printk(KERN_INFO "cma_dma_pl: Driver abort\n");
}

module_init(kmem_init); 
module_exit(kmem_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Oorzhak Naydan");
MODULE_DESCRIPTION("Driver for allocating a contiguous memory area");
MODULE_VERSION("2.1");