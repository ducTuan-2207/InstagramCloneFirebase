import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

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
    
    func makeAlert(titleInput: String, messageInput: String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
        
    }
    
    // Hàm xử lý sự kiện khi người dùng nhấn vào nút upload
    @IBAction func actionButtonClicked(_ sender: Any) {
        let storage = Storage.storage()
        let storageReference = storage.reference()
        let mediaFolder = storageReference.child("media")
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5) {
            let uuid = UUID().uuidString
            let imageRefence = mediaFolder.child("\(uuid).jpg")
            imageRefence.putData(data) { metadata, error in
                if let error = error {
                    self.makeAlert(titleInput: "Error", messageInput: error.localizedDescription)
                } else {
                    imageRefence.downloadURL { url, error in
                        guard let downloadURL = url else {
                            self.makeAlert(titleInput: "Error", messageInput: "Failed to get download URL.")
                            return
                        }
                        
                        // Database
                        let firestoreDatabase = Firestore.firestore()
                        var firestoreReference: DocumentReference? = nil
                        let firebasePost = [
                            "imageUrl": downloadURL.absoluteString,
                            "postedBy": Auth.auth().currentUser?.email ?? "",
                            "postComment": self.commentText.text ?? "",
                            "date": Timestamp(), // Sử dụng Timestamp để lưu thời gian hiện tại
                            "like": 0
                        ]
                        
                        firestoreReference = firestoreDatabase.collection("Losts").addDocument(data: firebasePost) { error in
                            if let error = error {
                                self.makeAlert(titleInput: "Error!", messageInput: error.localizedDescription)
                            } else {
                                self.makeAlert(titleInput: "Success!", messageInput: "Upload successfully.")
                            }
                        }
                    }
                }
            }
        } else {
            self.makeAlert(titleInput: "Error", messageInput: "Failed to get image data.")
        }
    }
}
