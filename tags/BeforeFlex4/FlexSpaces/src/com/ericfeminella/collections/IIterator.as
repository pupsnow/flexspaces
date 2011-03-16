/*
 Copyright (c) 2006 - 2007 Eric J. Feminella  <eric@ericfeminella.com>
 All rights reserved.

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is furnished
 to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
 INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
 PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

 @internal
 */

 package com.ericfeminella.collections
 {
    /**
     * 
     * Defines the contract for concrete Iterator implementations
     * which must provide an API for traversing an aggregate object
     * 
     */
    public interface IIterator
    {
        /**
         *
         * Determines if there are elements remaining in the 
         * aggregate
         *
         * @return true if an element remains, false if not
         *
         */
       function hasNext() : Boolean;

        /**
         *
         * Retrieves the next element in the aggregate
         *
         * @return next element based on the current index
         *
         */
       function next() : *;

       /**
        *
        * Resets the cursor / index of the Iterator to 0
        *
        */
       function reset() : void;

       /**
        *
        * Determines the position of the current element in 
        * the aggreagate
        *
        * @return  the current index of the aggreagate
        *
        */
       function position() : int;

       /**
        *
        * Remove must be implemented to provide a standard iterator
        * implementation.
        *
        * <p>
        * Typically this method would not provide an actual implementation
        * as an iterator is not to perform modifications, but rather
        * simply provide a mechanism for iterating an object and thus an
        * iterator is to be considered read-only.
        * </p>
        *
        * <p>
        * For implementations which do not provide support for
        * <code>remove</code> it is recommeneded that an exception
        * is thrown, typically of type UnsupportedOperationException
        * </p>
        *
        */
       function remove() : void;
   }
}
