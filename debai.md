##	Chương trình Primes
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
