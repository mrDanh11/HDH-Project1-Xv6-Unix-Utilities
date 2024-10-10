#include "kernel/types.h"
#include "kernel/fcntl.h"
#include "user/user.h"

// khởi tạo bộ nhớ đệm để write và read 1 byte
char buffer[1];

// write 1 byte
void ping(int p[]){
    char byte = 'a';
    int rs = write(p[1], &byte, 1);      // ghi 1 byte vào p[1] của pipe

    if(rs == -1){
        fprintf(2, "write failed!!\n");
        exit(1);
    }

}

// read 1 byte 
void pong(int p[]){
    int rs = read(p[0], buffer, 1);      // đọc 1 byte từ p[0] của pipe ra buffer
    if(rs == -1){
        fprintf(2, "read failed!!\n");
        exit(1);
    }
    printf("%d: received ping\n", getpid());    // hàm getpid() để lấy process id của tiến trình đó
}

void pingpong(int p[]){
    int pid;

    // tạo pipe bằng hàm pipe();
    if(pipe(p) < 0){
        fprintf(2, "pingpong: pipe failed!!\n");
        exit(1);
    }

    // tạo tiến trình con
    pid = fork();

    if(pid < 0){
        fprintf(2, "pingpong: fork failed!!\n");
        exit(1);
    }       
    else if(pid == 0){      // tiến trình con
        close(p[1]);    // đóng đầu ghi lại
        pong(p);        // nhận byte từ cha
        write(p[1], buffer, 1); // Gửi lại byte cho cha
        close(p[0]);    // đóng đầu đọc
        exit(0);
    }
    else{       // tiến trình cha
        close(p[0]);    // đóng đầu đọc
        ping(p);       // gửi 1 byte cho con
        wait(0);    // chờ tiến trình con kết thúc
        read(p[0], buffer, 1);  // đọc byte từ tiến trình con
        printf("%d: received pong\n", getpid());
        close(p[1]);    // đóng đầu ghi
        exit(0);
    }

}

int main(int argc, char *argv[]) {
    if(argc < 1){
        fprintf(2, "Usage: pingpong\n");
        exit(1);
    }

    int p[2]; // tạo mảng đề lưu pipe, p[0]: pipe để đọc, p[1]: pipe để ghi
    pingpong(p);

}
