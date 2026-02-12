#pragma once
#include <windows.h>
#include <memoryapi.h>
#include <winternl.h>
class Memory
{
public:
    LPVOID VirtualAllocTMATS(LPVOID lpAddress, SIZE_T dwSize, DWORD flAllocationType, DWORD flProtect)
    {
        return VirtualAlloc(lpAddress, dwSize, flAllocationType, flProtect);
    }
    BOOL VirtualFreeLPVOID_SIZET_DWORD(LPVOID lpAddress, SIZE_T dwSize, DWORD dwFreeType)
    {
        return VirtualFree(lpAddress, dwSize, dwFreeType);
    }

    RAM
};
