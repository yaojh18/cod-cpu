file_name=$1

mkdir ./${file_name}
cp ./${file_name}.s ./${file_name}/code.s
cd ./${file_name}

riscv64-unknown-elf-c++ -nostdlib -nostdinc -static -g -Ttext 0x0 code.s -o code.elf -march=rv32i -mabi=ilp32
riscv64-unknown-elf-objcopy -O binary code.elf code.bin
dd if=/dev/urandom of=code_4M.bin bs=1M count=4
dd if=code.bin of=code_4M.bin conv=notrunc
riscv64-unknown-elf-objdump -d code.elf > code.asm
