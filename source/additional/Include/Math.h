#include <cmath>

__declspec(dllexport) long double powerLD(long double x, long double y){return pow(x, y);}
__declspec(dllexport) double logarithmD(double X){return log(X);}
__declspec(dllexport) double addD(double a, double b){return a + b;}
__declspec(dllexport) long long addLL(long long a, long long b){return a + b;}
__declspec(dllexport) long long subLL(long long a, long long b){return a - b;}
__declspec(dllexport) double subD(double a, double b){return a - b;}
 double mulD(double a, double b){return a * b;}
 long long mulLL(long long a, long long b){return a * b;}
long long divLL(long long a, long long b){return a / b;}
double divD(double a, double b){return a / b;}