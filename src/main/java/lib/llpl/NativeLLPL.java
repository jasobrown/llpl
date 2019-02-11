package lib.llpl;

import java.util.Collections;

class NativeLLPL
{
    static {
        try {
            com.sun.jna.Native.register(com.sun.jna.NativeLibrary.getInstance("pmemllpl", Collections.emptyMap()));
        } catch (NoClassDefFoundError e) {
            throw new RuntimeException("JNA not found; cannot invoke pmemllpl functions", e);
        } catch (UnsatisfiedLinkError e) {
            throw new RuntimeException("Failed to link the pmemllpl library against JNA.", e);
        } catch (NoSuchMethodError e) {
            throw new RuntimeException("Obsolete version of JNA present; unable to register C library. Upgrade to JNA 4.0 or later", e);
        }
    }


    public static native long pmemllpl_heap_alloc_tx(long poolHandle, long size, int class_index);
    public static native long pmemllpl_heap_alloc_atomic(long poolHandle, long size, int class_index);

    public static native int pmemllpl_heap_free_tx(long poolHandle, long addr);
    public static native int pmemllpl_heap_free_atomic(long addr);

    public static synchronized native long pmemllpl_heap_open(String path, long size);
    //    public static synchronized native long pmemllpl_heap_open(String path, long size, long[] allocationClasses);
    public static synchronized native int pmemllpl_heap_register_alloc_class(long poolHandle, long size);
    public static synchronized native void pmemllpl_heap_close(long poolHandle);

    public static synchronized native int pmemllpl_heap_set_root(long poolHandle, long val);
    public static synchronized native long pmemllpl_heap_get_root(long poolHandle);
    public static native long pmemllpl_heap_direct_addr(long poolId, long offset);
    public static native long pmemllpl_heap_size(String path);

    public native static int pmemllpl_memblock_add_to_tx(long poolHandle, long address, long size);

    public static native int pmemllpl_tx_start(long poolHandle);
    public static native void pmemllpl_tx_commit();
    public static native void pmemllpl_tx_end();
    public static native void pmemllpl_tx_abort();
    public static native int pmemllpl_tx_state();
}
