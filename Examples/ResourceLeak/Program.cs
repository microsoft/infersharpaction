// Copyright (c) Microsoft Corporation.
// Licensed under the MIT license.

using System.IO;

namespace ResourceLeak
{
    class Program
    {
        static void Main(string[] args)
        {
            var streamReader = new StreamReader("somefile.txt");
            streamReader.ReadToEnd();
            // FIXME: Should do streamReader.Close(), otherwise resource leak.
        }
    }
}