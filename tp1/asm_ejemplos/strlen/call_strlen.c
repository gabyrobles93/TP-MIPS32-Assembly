size_t count (char ** strv, size_t len) {
    size_t c = 0;
    char * s;

    while (len) {
        s =  * strv;
        strv++;
        c += strlen(s);
        len--;
    }
}