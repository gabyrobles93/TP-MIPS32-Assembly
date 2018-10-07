size_t strlen(char * str) {
    size_t n = 0;
    while (*str) {
        str++;
        n++;
    }
    return n;
}