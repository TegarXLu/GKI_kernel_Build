#include <linux/init.h>
#include <linux/module.h>
#include <linux/kernel.h>

static int __init kpm_init(void) {
    pr_info("KPM Module Loaded (dummy)\n");
    return 0;
}

static void __exit kpm_exit(void) {
    pr_info("KPM Module Unloaded (dummy)\n");
}

module_init(kpm_init);
module_exit(kpm_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("TegarXLu");
MODULE_DESCRIPTION("Dummy KPM Module for SukiSU/SUSFS Integration");
