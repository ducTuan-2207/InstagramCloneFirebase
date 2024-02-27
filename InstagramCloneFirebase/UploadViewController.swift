import UIKit
import FirebaseStorage

class UpdateViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentText: UITextField!
    @IBOutlet weak var uploadButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Cho phép người dùng tương tác với imageView
        imageView.isUserInteractionEnabled = true
        
        // Thêm một gesture recognizer để xử lý double tap vào imageView
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        gestureRecognizer.numberOfTapsRequired = 2 // Phát hiện double tap
        imageView.addGestureRecognizer(gestureRecognizer)
    }
    
    // Hàm được gọi khi imageView nhận double tap
    @objc func chooseImage() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
    }
    
    // Hàm được gọi khi người dùng chọn một hình ảnh từ thư viện ảnh
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        dismiss(animated: true)
    }
    
    // Hàm xử lý sự kiện khi người dùng nhấn vào nút upload
    @IBAction func actionButtonClicked(_ sender: Any) {
        let storage = Storage.storage()
        let storageReference = storage.reference()
        let mediaFolder = storageReference.child("media")
        
        if let imageData = imageView.image?.jpegData(compressionQuality: 0.5) {
            let imageRefence = mediaFolder.child("image.jpg")
            
            // Tải lên dữ liệu hình ảnh vào Firebase Storage
            imageRefence.putData(imageData, metadata: nil) { (metadata, error) in
                if let error = error {
                    // Xử lý lỗi (nếu có)
                    print("Error uploading image: \(error.localizedDescription)")
                } else {
                    // Nếu không có lỗi, in ra thông tin metadata của hình ảnh đã tải lên (nếu cần)
                    print("Image uploaded successfully!")
                    
                    // Lấy URL của hình ảnh đã tải lên
                    imageRefence.downloadURL { (url, error) in
                        if let error = error {
                            // Xử lý lỗi (nếu có)
                            print("Error getting download URL: \(error.localizedDescription)")
                        } else if let downloadURL = url {
                            // Lấy URL thành công, bạn có thể sử dụng downloadURL ở đây
                            let imageURLString = downloadURL.absoluteString
                            print("Download URL: \(imageURLString)")
                            
                            // Nếu muốn thực hiện bất kỳ hành động nào khác sau khi tải lên hình ảnh thành công, bạn có thể thực hiện ở đây.
                            
                            // Ví dụ: Gửi downloadURL đến một API, lưu trữ vào cơ sở dữ liệu, hiển thị trên giao diện người dùng, vv.
                        }
                    }
                }
            }
        } else {
            print("No image selected!")
        }
    }}
