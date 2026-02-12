#pragma once
#include <windows.h>
#include <sysinfoapi.h>
#include <versionhelpers.h>
#include <winternl.h>

inline BOOL IsWinVersion10ORAboveNA()
{
    return IsWindows10OrGreater();
}
inline BOOL IsWinVersion8Point1ORAboveNA()
{
    return IsWindows8Point1OrGreater();
}
inline BOOL IsWinVersion7ORAboveNA()
{
    return IsWindows7OrGreater();
}
inline BOOL IsWinVersionXPOrAboveNA()
{
    return IsWindowsXPOrGreater();
}
// enough version stuff for today
void SystemTimeLP(LPSYSTEMTIME lpSystemTime)
{
    GetSystemTime(lpSystemTime);
}
BOOL GetVersionExA_LPOS(LPOSVERSIONINFOA lpVersionInformation)
{
    return GetVersionExA(lpVersionInformation);
}