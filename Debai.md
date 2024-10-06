# HỆ ĐIỀU HÀNH
## PROJECT 1 –Xv6 and Unix Utilities
1.	 Quy tắc chung:
- Project được thực hiện theo nhóm: mỗi nhóm có tối đa 3 sinh viên
- Tất cả các bài tập giống nhau sẽ được chấm 0 điểm trong toàn bộ quá trình thực hành (mặc dù các bài tập và dự án thực hành khác cũng được chấm điểm).
- Môi trường cài đặt: Linux
2.	 Nộp bài:
Nộp bài tập trực tiếp trên trang web của khóa học (MOODLE), không chấp nhận bài nộp qua email hoặc các hình thức khác.
Tên tệp: StudentID1_StudentID2_StudentID3.zip (với StudentID1 < StudentID2< StudentID3)
VD: Nhóm của bạn có 2 sinh viên: 2312001 và 2312002, tên tệp là: 2312001_2312002_2312003.zip
Bao gồm:
•	StudentID1_StudentID2_StudentID3_Report.pdf: Báo cáo nên ngắn gọn và súc tích. Không cố gắng đưa mã nguồn vào báo cáo. Mục đích của báo cáo là để bạn có cơ hội làm rõ giải pháp của mình, nêu ra những khó khăn gặp phải, và bổ sung thông tin hữu ích cho việc chấm điểm. Nếu bạn gặp vấn đề cụ thể, thử các phương pháp không thành công, hoặc có yêu cầu chưa được thực hiện đầy đủ, thì việc giải thích trong báo cáo có thể giúp chúng tôi đánh giá và chấm điểm một cách công bằng hơn.
●	Realease : Tệp diff (bản vá diff, Ví dụ: $ git diff > 
< StudentID1_StudentID2_StudentID3 .patch)
●	Source : Tệp Zip của xv	6 (phiên bản được make clean)
Lưu ý: Cần thực hiện đúng các yêu cầu trên, nếu không, bài làm sẽ không được chấm.
3.	 Đánh giá
Bài làm của nhóm sẽ được chấm điểm dựa trên tính hoàn thiện, tính chính xác, phong cách lập trình, mức độ kiểm tra kỹ lưỡng, giải pháp và sự hiểu biết về mã nguồn.
Khi quản lý khóa học này, chúng tôi cố gắng hết sức để đánh giá công bằng từng cá nhân dựa trên sự đóng góp của mỗi người cho dự án.
4.	Yêu cầu
Bài thực hành này sẽ giúp bạn làm quen với xv6 và các system call của nó
1.	Chương trình sleep
Triển khai chương trình sleep cấp độ người dùng cho xv6, dựa theo lệnh sleep của UNIX. Chương trình Sleep của bạn sẽ tạm dừng theo số ticks do người dùng chỉ định. Một tick là khái niệm về thời gian được định nghĩa bởi kernel xv6, cụ thể là thời gian giữa hai lần ngắt từ timer chip. Giải pháp của bạn sẽ nằm trong tệp user/sleep.c.
Một số gợi ý:
●	Trước khi bạn bắt đầu viết mã, hãy đọc Chương 1 của xv6 book .
●	Tạo một file code tại user/sleep.c . Xem một số chương trình khác trong user/ (ví dụ: user/echo.c, user/grep.c và user/rm.c) để xem cách các đối số dòng lệnh được truyền đến một chương trình.
●	Thêm chương trình sleep của bạn vào UPROGS trong Makefile ; sau khi thực hiện xong, make qemu sẽ biên dịch chương trình của bạn và bạn có thể chạy nó từ shell xv6.
●	Nếu người dùng quên truyền đối số, lệnh sleep sẽ in ra thông báo lỗi.
●	Đối số dòng lệnh được truyền dưới dạng chuỗi; bạn có thể chuyển đổi nó thành số nguyên bằng atoi (xem user/ulib.c).
●	Sử dụng lệnh gọi hệ thống sleep.
●	Xem kernel/sysproc.c để biết kernel xv6 triển khai lệnh gọi hệ thống sleep (tìm sys_sleep), user/user.h để biết định nghĩa C của lệnh sleep có thể gọi được từ chương trình người dùng và user/usys.s để biết code trình biên dịch nhảy từ code người dùng vào kernel để sleep.
●	Hàm chính của sleep sẽ gọi exit(0) khi nó hoàn tất.
●	Tham khảo cuốn sách Ngôn ngữ lập trình C (ấn bản thứ hai) (K&R) của Kernighan và Ritchie để tìm hiểu về C.
Chạy chương trình từ shell xv6:
     
$ make qemu 
... 
init: starting sh 
$ sleep 10 
(nothing happens for a little while)
$
   
Chương trình của bạn sẽ tạm dừng khi chạy như hiển thị ở trên. Chạy make grade trong dòng lệnh của bạn (bên ngoài qemu) để xem bạn có vượt qua bài kiểm tra sleep không.
Lưu ý rằng make grade chạy tất cả các bài test, bao gồm cả các bài test cho các tác vụ bên dưới. Nếu bạn muốn chạy các bài test grade cho một tác vụ, hãy nhập:
$ ./grade-lab-util sleep
  
Thao tác này sẽ chạy các bài kiểm tra điểm phù hợp với "Sleep". Hoặc, bạn có thể nhập:
$ make GRADEFLAGS=sleep grade
  
cũng có tác dụng tương tự.
2.	Chương trình Ping pong
Viết một chương trình người dùng sử dụng lệnh gọi hệ thống xv6 để ''ping-pong'' một byte giữa hai tiến trình qua một cặp pipe (tương ứng với gởi và nhận). Tiến trình cha sẽ gửi một byte cho tiến trình con; tiến trình con sẽ in " <pid>: received ping ", trong đó <pid> là ID tiến trình của nó , ghi byte vào pipe cho tiến trình cha và thoát; tiến trình cha sẽ đọc byte từ tiến trình con, in " <pid>: received pong " và thoát. Giải pháp của bạn sẽ nằm trong tệp user/pingpong.c .
Một số gợi ý:
●	Thêm chương trình vào UPROGS trong Makefile .
●	Bạn sẽ cần sử dụng các lệnh gọi hệ thống pipe , fork , write , read và getpid .
●	Các chương trình người dùng trên xv6 có một tập hợp hạn chế các hàm thư viện có sẵn. Bạn có thể xem danh sách trong user/user.h ; (ngoại trừ các lệnh gọi hệ thống) nằm trong user/ulib.c , user/printf.c và user/umalloc.c .
Chạy chương trình từ shell xv6 và nó sẽ tạo ra kết quả sau:
    $ make qemu
    ...
    init: starting sh
    $ pingpong
    4: received ping
    3: received pong
    $
 
Chương trình của bạn sẽ trao đổi một byte giữa hai tiến trình và tạo ra đầu ra như hiển thị ở trên. Chạy make grade để kiểm tra.
3.	Chương trình Primes
Viết một chương trình sàng nguyên tố đồng thời cho xv6 sử dụng các pipe và thiết kế minh họa trong hình ở giữa trang này và nội dung xung quanh. Ý tưởng này là của Doug McIlroy, người phát minh ra Unix Pipes. Giải pháp của bạn phải nằm trong tệp user/primes.c.
Mục tiêu của bạn là sử dụng pipe và fork để thiết lập pipeline. Quy trình đầu tiên đưa các số từ 2 đến 280 vào pipeline. Đối với mỗi số nguyên tố, bạn sẽ sắp xếp để tạo một quy trình đọc từ hàng xóm bên trái của nó qua một pipe và ghi vào hàng xóm bên phải của nó qua một pipe khác. Vì xv6 có số lượng mô tả tệp và quy trình hạn chế, nên quy trình đầu tiên có thể dừng ở 280.
Một số gợi ý:
●	Hãy cẩn thận khi đóng các tập tin mô tả mà một tiến trình không cần, nếu không chương trình của bạn sẽ chạy hết tài nguyên trước khi tiến trình đầu tiên đạt đến 280.
●	Khi tiến trình đầu tiên đạt đến 280, nó phải đợi cho đến khi toàn bộ pipe kết thúc, bao gồm tất cả các tiến trình con, cháu, v.v. Do đó, tiến trình primes chính chỉ nên thoát sau khi tất cả đầu ra đã được in và sau khi tất cả các tiến trình primes khác đã thoát.
●	Gợi ý: read trả về số không khi phía ghi của pipe bị đóng.
●	Cách đơn giản nhất là ghi trực tiếp các số nguyên 32 bit (4 byte) vào các pipe, thay vì sử dụng định dạng ASCII I/O 
●	Bạn chỉ nên tạo các tiến trình trong pipe khi cần thiết.
●	Thêm chương trình vào UPROGS trong Makefile.
●	Nếu bạn nhận được lỗi đệ quy vô hạn từ trình biên dịch cho hàm primes, bạn có thể phải khai báo void primes(int) __attribute__((noreturn)); để chỉ ra rằng hàm primes không trả về.
Giải pháp của bạn phải triển khai sàng dạng ống và tạo ra kết quả đầu ra sau:
    $ make qemu
    ...
    init: starting sh
    $ primes
    prime 2
    prime 3
    prime 5
    prime 7
    prime 11
    prime 13
    prime 17
    prime 19
    prime 23
    prime 29
    prime 31
    ...
    $
 
4.	Chương trình Find
Viết một phiên bản đơn giản của chương trình find của UNIX cho xv6: tìm tất cả các tệp trong cây thư mục có tên cụ thể. Giải pháp của bạn phải nằm trong tệp user/find.c.
Một số gợi ý:
●	Hãy xem user/ls.c để biết cách đọc thư mục.
●	Sử dụng đệ quy để cho phép tìm kiếm xuống các thư mục con.
●	Không đệ quy vào "." và "..".
●	Những thay đổi đối với hệ thống tập tin vẫn tồn tại trong suốt quá trình chạy qemu; để có được hệ thống tập tin sạch, hãy chạy make clean rồi make qemu.
●	Bạn sẽ cần sử dụng chuỗi trong C. 
●	Lưu ý rằng == không so sánh các chuỗi như trong Python. Hãy sử dụng strcmp() thay thế.
●	Thêm chương trình vào UPROGS trong Makefile.
Giải pháp của bạn sẽ tạo ra kết quả sau (khi hệ thống tệp chứa các tệp b, a/b và a/aa/b):
    $ make qemu
    ...
    init: starting sh
    $ echo > b
    $ mkdir a
    $ echo > a/b
    $ mkdir a/aa
    $ echo > a/aa/b
    $ find . b
    ./b
    ./a/b
    ./a/aa/b
    $
 
Chạy make grade để xem thử nghiệm của chúng tôi cho kết quả như thế nào.
5.	xargs
Viết một phiên bản đơn giản của chương trình xargs UNIX cho xv6: các đối số của chương trình mô tả lệnh để chạy. Chương trình đọc các dữ liệu từ đầu vào chuẩn và chạy lệnh sau đó sử dụng kết quả của lệnh này làm đối số cho lệnh khác. Giải pháp của bạn phải nằm trong tệp user/xargs.c.
Ví dụ sau minh họa xarg:
   $ echo hello too | xargs echo bye
    bye hello too
   $
 
Lưu ý rằng lệnh ở đây là "echo bye" và các đối số bổ sung là "hello too", trở thành lệnh "echo bye hello too" trả về kết quả là "bye hello too".
Lưu ý rằng xargs trên UNIX có thể tối ưu hóa bằng cách cung cấp nhiều đối số cho lệnh cùng một lúc. Chúng tôi không yêu cầu bạn thực hiện tối ưu hóa này. Để xargs trên UNIX hoạt động như mong muốn cho bài tập này, vui lòng sử dụng tùy chọn -n 1 để đảm bảo chỉ truyền một đối số mỗi lần. Ví dụ
   $ (echo 1 ; echo 2) | xargs -n 1 echo
   1
   2
   $
 
Một số gợi ý:
●	Sử dụng fork và exec để gọi lệnh trên mỗi dòng đầu vào. Sử dụng wait trong parent để chờ child hoàn tất lệnh.
●	Để đọc từng dòng dữ liệu đầu vào, hãy đọc từng ký tự cho đến khi xuất hiện dấu xuống dòng ('\n').
●	kernel/param.h khai báo MAXARG, có thể hữu ích nếu bạn cần khai báo một mảng argv.
●	Thêm chương trình vào UPROGS trong Makefile.
●	Những thay đổi đối với hệ thống tập tin vẫn tồn tại trong suốt quá trình chạy qemu; để có được hệ thống tập tin sạch, hãy chạy make clean rồi make qemu.
xargs, find và grep kết hợp tốt:
$ find . b | xargs grep hello
 
sẽ chạy "grep hello" trên mỗi tệp có tên b trong các thư mục bên dưới ".".
Để kiểm tra giải pháp của bạn cho xargs, hãy chạy tập lệnh shell xargstest.sh. Giải pháp của bạn sẽ tạo ra kết quả sau:
  $ make qemu
  ...
  init: starting sh
  $ sh < xargstest.sh
  $ $ $ $ $ $ hello
  hello
  hello
  $ $
 
Bạn có thể phải quay lại và sửa lỗi trong chương trình tìm kiếm của mình. Đầu ra có nhiều $ vì shell xv6 không nhận ra rằng nó đang xử lý lệnh từ tệp thay vì từ bảng điều khiển và in $ cho mỗi lệnh trong tệp.

6. Thang điểm:
STT	Chương trình	Điểm
1	pingpong	2.5
2	primes	2.5
3	find	2.5
4	xargs	2.5

7. Tài liệu tham khảo:
https://pdos.csail.mit.edu/6.1810/2024/labs/util.html
