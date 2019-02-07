/* 
 * Copyright (C) 2018 Intel Corporation
 *
 * SPDX-License-Identifier: BSD-3-Clause
 * 
 */

package lib.llpl;

import java.util.function.Consumer;

/**
 * Implements a read and write interface for accessing a {@code Heap}. Access through a 
 * {@code MemoryBlock} is bounds-checked to be within the blocks allocated space.   
 */
public final class MemoryBlock extends AbstractMemoryBlock {
    private static final long METADATA_SIZE = 8;

    MemoryBlock(Heap heap, long size, boolean transactional) {
        super(heap, size, true, transactional);
    }

    MemoryBlock(Heap heap, long poolHandle, long offset) {
        super(heap, poolHandle, offset, true);
    }

    /**
     * Checks that the range of bytes from {@code offset} (inclusive) to {@code offset} + length (exclusive) 
     * is within the bounds of this memory block. 
     * @param offset The start if the range to check
     * @param length The number of bytes in the range to check
     * @throws IndexOutOfBoundsException if the range is not within this memory block's bounds
     */
    public void checkBounds(long offset, long length) {
        super.checkBounds(offset, length);
    }

    @Override
    long baseOffset() { 
        return METADATA_SIZE; 
    }

    /**
     * Returns the allocated size, in bytes, of this memory block.  
     * @return the allocated size, in bytes, of this memory block
     */
    @Override
    public long size() { 
        return super.size(); 
    }

    /**
    * Ensures that any modifications made to this memory block are written to persistent memory media.
    */
    @Override
    public void flush() {
        flush(0, size());
    }
}

