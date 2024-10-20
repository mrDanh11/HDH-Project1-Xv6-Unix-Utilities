#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(int argc, char *argv[]){
   char line[200];//Chua 199 ki tu
   int cnt_line=0;//Bien dem cua line
   char buffer;
   //Doc tu stdin tung byte 1 (1 ky tu) luu vao line
   while(read(0, &buffer, 1)){
       if(buffer != '\n'){
           line[cnt_line]=buffer;
           cnt_line++;
       }else break;//Dung khi thay \n
   }
   //Them dau \0 cho line
   line[cnt_line]='\0';




   printf("Line: ");
   write(1,line, cnt_line);
   printf("\n");


   printf("Argv[2]: ");
   write(1,argv[2], strlen(argv[2]));
   printf("\n");


   //Dung ham fork() tao tien trinh con
   int pid = fork();
   //Neu la tien trinh cha
   if(pid!=0){
       wait(0);
       exit(0);
   }
   //Neu la tien trinh con
   else if(pid == 0){
       //Tao mang args chua cac tham so de chay ham
       char* args[3];
       args[0]=argv[2];
       args[1]=line;
       args[2]=0;
       printf("Exec: ");
       //argv[0] la xarg
       //argv[1] la echo
       //argv[2] la bye
       exec(argv[1], args);
       printf("exec failed\n");
   }
}

