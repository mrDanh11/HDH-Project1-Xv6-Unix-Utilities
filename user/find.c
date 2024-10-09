#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"
#include "kernel/fcntl.h"

void
find(char *path, char *file)
{
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  // Mở thư mục, nếu không mở được thì return
  if((fd = open(path, O_RDONLY)) < 0){
    return;
  }
  // Lấy thông của thư mục vừa mở
  // Nếu không đọc được thì đóng thư mục và return
  if(fstat(fd, &st) < 0){
    close(fd);
    return;
  }
  
  // Kiểm tra st có phải là thư mục hay không
  if (st.type == T_DIR){
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
      printf("find: path too long\n");
      close(fd);
      return;
    }
    // Tạo đường dẫn tạm có / ở cuối để chuẩn bị cho các thư mục con
    // p là con trỏ đến đường dẫn buf
    strcpy(buf, path);
    p = buf+strlen(buf);
    *p++ = '/';

    // Duyệt qua các đối tượng con
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
      // Bỏ qua các thư mục không hợp lệ
      if(de.inum == 0)
        continue;

      // Tạo đường dẫn đến từng đối tượng con
      memmove(p, de.name, DIRSIZ);
      p[DIRSIZ] = 0;
      
      // Không đệ quy vào "." và ".."
      if (strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0){
        continue;
      }

      // Đọc thông tin của đường dẫn tạm
      if (stat(buf, &st) < 0){
        continue;
      }
      
      // So sánh tên tập tin con với tên cần tìm, nếu đúng thì in ra
      if (strcmp(de.name, file) == 0){
        printf("%s\n", buf);
      }
      
      // Nếu đối tượng con là thư mục
      if (st.type == T_DIR){
        find(buf, file);
      }

    }
    close(fd);
  } 
}

int
main(int argc, char *argv[])
{ 
  if(argc != 3){
    fprintf(2, "find <path> <filename>\n");
    exit(1);
  }

  find(argv[1], argv[2]);
  exit(0);
}
