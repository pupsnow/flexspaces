/*
 Copyright (c) 2006 - 2008  Eric J. Feminella  <eric@ericfeminella.com>
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
     * Defines the contract for concrete Enumeration implementations
     * which must provide an API for generating a series of elements
     * from which each element can be accessed successively.
     *
     */
    public interface IEnumeration
    {
        /**
         *
         * Determines if there are remaining elements in the object
         *
         * @return true if elements remain, otherwise false
         *
         */
        function hasMoreElements() : Boolean;

        /**
         *
         * Retrieves the next element in the Enumeration. If no other
         * elements exist a null value is returned or an exception is
         * thrown
         *
         * @return the next element in the enumeration
         *
         */
        function nextElement() : *;
    }
}
