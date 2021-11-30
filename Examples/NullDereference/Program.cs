// Copyright (c) Microsoft Corporation.
// Licensed under the MIT license.

namespace NullDereference
{
    class Program
    {
        static void Main(string[] args)
        {
            
            string testString = null;
            _ = testString.Length;
        }
    }
}