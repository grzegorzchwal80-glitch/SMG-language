#include <iostream>
#include <Windows.h>
#include <ShlObj.h>

auto &out = std::cout;

struct Installer
{
    BOOL CanAccessRegistry;
};

void MakeDataFile(const Installer &inst)
{
    const char *localAppData = getenv("LOCALAPPDATA");
    if (!localAppData)
        return;

    std::string folder = std::string(localAppData) + "\\SMGData";
    CreateDirectoryA(folder.c_str(), NULL);

    std::string filePath = folder + "\\Data.json";

    HANDLE hFile = CreateFileA(
        filePath.c_str(),
        GENERIC_WRITE,
        0,
        NULL,
        CREATE_ALWAYS,
        FILE_ATTRIBUTE_NORMAL,
        NULL);

    if (hFile != INVALID_HANDLE_VALUE)
    {
        std::string json = "{\n";
        json += "    \"can_access_registry\": " + std::string(inst.CanAccessRegistry ? "true" : "false") + ",\n";
        json += "    \"version\": \"latest\",\n";
        json += "    \"installed_at\": \"\"\n";
        json += "}";
        // math
        DWORD written;
        WriteFile(hFile, json.c_str(), (DWORD)json.size(), &written, NULL);
        CloseHandle(hFile);
    }
}

void Install(Installer inst)
{
    out << "Hello!\nWelcome to the installation process for SMG.\nI couldnt make this UI, cuz its hard as HELL (and gives 3x more size)\nSo first,\n";

    if (IsUserAnAdmin())
    {
        char YN;
        out << "Can SMG access the registry for HKEY_LOCAL_MACHINE? This is for admin rights ONLY,\n and because this was turned on as admin, it will be local machine, not user.\n Turn on as non admin, and the registry will be changed for only your account.\n So, do you agree? Y/N\n";
        std::cin >> YN;
        inst.CanAccessRegistry = (YN == 'Y' || YN == 'y');
    }
    else
    {
        char YN;
        out << "Can SMG access the registry for HKEY_CURRENT_USER? This program was booted as non-admin, so its for you, yes you, ONLY (only this account gets changed).\nSo, do you agree? Y/N\n";
        std::cin >> YN;
        inst.CanAccessRegistry = (YN == 'Y' || YN == 'y');
    }

    out << "Okay, now: SMG will live in the current directory when this file was run.\n";

    out << "SMG is getting installed, right away!\nDont get scared of any text.\n\n";

    MakeDataFile(inst);

    system(
        "powershell -command \"Invoke-WebRequest "
        "https://github.com/grzegorzchwal80-glitch/SMG-language/releases/latest/download/smginterpreter.zip "
        "-OutFile smginterpreter.zip\"");
    system("powershell -command \"Expand-Archive -Force smginterpreter.zip .\"");
}
int main(int argc, char const *argv[])
{
    Installer inst;

    if (argc > 1)
    {
        std::string arg = argv[1];

        if (arg == "-Install" || arg == "-install" || arg == "install")
        {
            Install(inst);
            return 0;
        }
        else if (arg == "-srconly")
        {
            system("git clone https://github.com/grzegorzchwal80-glitch/SMG-language");
            return 0;
        }
        else if (arg == "-help")
        {
            out << "Available ones are \n -Install, installs the newest ZIP file. \n -srconly, installs only the source folder. only 2MB." << "\n";
        }
    }

    Install(inst);
    return 0;
}