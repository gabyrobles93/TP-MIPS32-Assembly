N=1;
while :; do
head -c $N </dev/urandom >/tmp/in.bin;
tp1 -a encode -i /tmp/in.bin -o /tmp/out.b64;
tp1 -a decode -i /tmp/out.b64 -o /tmp/out.bin;
if diff /tmp/in.bin /tmp/out.bin; then :; else
echo ERROR: $N;
break;
fi
echo ok: $N;
N=$((N+1))
rm -f /tmp/in.bin /tmp/out.b64 /tmp/out.bin
done
