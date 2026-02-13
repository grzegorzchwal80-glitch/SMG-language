#pragma once
#include <windows.h>
#include <winuser.h>
#include <errhandlingapi.h>
#include <synchapi.h>
#include <processthreadsapi.h>
#include <shlobj.h>

void MessageBoxA_LPCSTR2_UINT(HWND hwnd, LPCSTR MainText, LPCSTR Caption, UINT TypeUsingMB)
{
    if (hwnd == 0)
    {
        hwnd = NULL;
        MessageBoxA(hwnd, MainText, Caption, TypeUsingMB);
    }
    else
    {
        MessageBoxA(hwnd, MainText, Caption, TypeUsingMB);
    }
}

BOOL IsUserAAdmin()
{
    return IsUserAnAdmin();
}