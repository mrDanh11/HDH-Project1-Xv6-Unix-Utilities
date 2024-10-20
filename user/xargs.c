#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(int argc, char *argv[]) {
    if (argc < 3) {
        printf("Usage: %s <command> <argument>\n", argv[0]);
        exit(1);
    }

    char line[200]; // Lưu trữ đầu vào từ stdin
    int cnt_line = 0;
    char buffer;

    // Đọc từ stdin từng ký tự một cho đến khi gặp '\n'
    while (read(0, &buffer, 1)) {
        if (buffer != '\n') {
            line[cnt_line++] = buffer;
        } else {
            break; // Dừng khi gặp ký tự xuống dòng '\n'
        }
    }
    line[cnt_line] = '\0'; // Thêm kết thúc chuỗi

    // Tạo tiến trình con
    int pid = fork();

    if (pid < 0) {
        printf("Fork failed\n");
        exit(1);
    }

    if (pid == 0) { // Tiến trình con
        char* args[4];
        args[0] = argv[1]; // argv[1] là lệnh "echo"
        args[1] = argv[2]; // argv[2] là từ "bye"
        args[2] = line;    // Chuỗi nhập từ stdin "hello too"
        args[3] = 0;       // Kết thúc mảng args

        exec(argv[1], args); // Thực thi lệnh echo với các tham số
        printf("exec failed\n"); // Nếu exec thất bại
        exit(1);
    } else { // Tiến trình cha
        wait(0); // Đợi tiến trình con hoàn thành
        exit(0);
    }
}

// note: trong ham exec(ten_chuong_trinh, mang_tham_so), muon chay dung thi ta can
// truyen lenh can chay vao ptu dau tien cua mang tham so (dieu nay la bat buoc trong he thong Unix/Linux)

