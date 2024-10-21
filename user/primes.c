#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fcntl.h"

#define MAX 280

int primes(int in, int prime) 
{
	int num;
	int out_fd[2];
    // Tạo pipe đầu ra
	pipe(out_fd);

	if (!fork()) {
        // Đọc từng số trong pipe in, số nào không chia hết cho số prime thì ghi vào out_fd
		while (read(in, &num, sizeof(int))) {
			if (num % prime) {
				write(out_fd[1], &num, sizeof(int));
			}
		}
		close(in);
		close(out_fd[1]);
		
		exit(0);
	}

	close(in);
	close(out_fd[1]);
    // trả về out_fd
	return out_fd[0];
}

int main(int argc, char *argv[]){
    int fd[2];
    pipe(fd);

    // Tạo tiến trình con để ghi các số từ 2 tới MAX vào fd
    if (!fork()){
        for (int i = 2; i < MAX; i++){
            write(fd[1], &i, sizeof(int));
        }
        // Đóng pipe và trở lại tiến trình cha
        close(fd[1]);
        exit(0);
    }

    close(fd[1]);

    int in = fd[0];
    int prime;
    // Lặp qua các số từ pipe fd (thông qua biến in), tiến hành lọc số nguyên tố thông qua hàm primes
    while (read(in, &prime, sizeof(int))){
        // In ra màn hình số nguyên tố ở đầu pipe fd
        printf("prime %d\n", prime);
        // Lọc các số chia hết cho prime ở trong pipe fd (biến in), trả về số nguyên tố tiếp theo
        in = primes(in, prime);
    }
    exit(0);   
}