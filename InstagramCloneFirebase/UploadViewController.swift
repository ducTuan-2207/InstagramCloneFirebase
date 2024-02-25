import UIKit

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
        // Thực hiện hành động tương ứng ở đây
    }
}
