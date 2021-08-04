//
//  SingInViewController.swift
//  Dreams
//
//  Created by SG on 2021/08/04.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore
import FirebaseStorage

class SingInViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordCheck: UITextField!
    
    @IBOutlet weak var profileIMG: UIImageView!
    
    @IBOutlet weak var ScrollView: UIScrollView!
    
    
    @IBOutlet weak var agreeBtn1: UIButton!
    @IBOutlet weak var agreeBtn2: UIButton!
    
    
    
    var agreeCode = 0
    
    let picker = UIImagePickerController() // 이미지 컨트롤러
    
    // Create left UIBarButtonItem.
    lazy var leftButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(buttonPressed(_:)))
        button.tag = 1
        return button
    }()

    
    
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    
    /* 알람창 띄우는 메시지 변수 */
    var createMessage: String = ""
    var createTrue: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.leftBarButtonItem = self.leftButton
        self.navigationController?.navigationBar.barTintColor = .white
     
        
        profileIMG.layer.cornerRadius = profileIMG.frame.height/2
        profileIMG.layer.borderWidth = 1
        profileIMG.clipsToBounds = true
        profileIMG.layer.borderColor = UIColor.clear.cgColor  //원형 이미지의 테두리 제거
        
        picker.delegate = self
        
        // scrollView 클릭시 키보드 내리기
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MyTapMethod))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
            
        ScrollView.addGestureRecognizer(singleTapGestureRecognizer)

        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
           self.view.endEditing(true)
     }
    @objc func MyTapMethod(sender: UITapGestureRecognizer) {
          self.view.endEditing(true)
      }
    
  
    
    
    @IBAction func agreeBtn1(_ sender: Any) {
        agreeBtn1.isSelected = !agreeBtn1.isSelected
    }
    @IBAction func agreeBtn2(_ sender: Any) {
        agreeBtn2.isSelected = !agreeBtn2.isSelected
    }
    
    
    
    @IBAction func agreeView1(_ sender: Any) {
        agreeCode = 0
        agreePageNext()
    }
    
    @IBAction func agreeView2(_ sender: Any) {
        agreeCode = 1
        agreePageNext()
    }
    
    
    func agreePageNext(){
       
         guard let rvc = self.storyboard?.instantiateViewController(withIdentifier:"AgreeViewController") as? AgreeViewController else {
             return
         }
         rvc.receiveCode = self.agreeCode // 약관동의 페이지의 사용자가 누른 약관동의 코드를 전송
         self.navigationController?.pushViewController(rvc, animated: true) // 약관내용보기로 이동
     }
    
    
    @IBAction func CreateUser(_ sender: Any) {
        
        if self.password.text! == self.passwordCheck.text!{  // 비밀번호랑 재확인 비밀번호가 일치하는지 확인
              if self.agreeBtn1.isSelected && self.agreeBtn2.isSelected{ // 약관동의가 모두 되어 있는지 확인
                 signupEvent() // 비밀번호 일치 & 약관을 모두 동의 할 경우 회원가입 하는 함수 호출
              } else {
                  createStopMessage(msg: "약관을 모두 동의해주세요.") // 약관을 모두 동의하지 않은 경우 알람창 호출
              }
          } else{
              createStopMessage(msg: "비밀번호가 일치하지 않습니다.") // 비밀번호가 일치하지 않은 경우 알람창 호출
          }
        
    }
    

    func signupEvent() {
        Auth.auth().createUser(withEmail: email.text!, password: password.text!) { (user, err) in
            
            print("특검 : \(user)")
            if user != nil {
            let uid = user!.user.uid
            self.createMessage = "회원가입이 완료되었습니다."
            self.createTrue = true
                
            self.db.collection("Users").document(uid).setData([
                "name": self.name.text!,
                "성별": "남녀",
            ]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
            
            
            guard let sendimage = self.profileIMG.image, let dataa = sendimage.jpegData(compressionQuality: 1.0) else {
                       return
                   }
             
            /* 이미지를 저장할 path 설정 */
           
            let riversRef = Storage.storage().reference().child(uid)
            
            
            /* 사용자가 선택한 이미지를 서버로 전송하는 부분 */
            riversRef.putData(dataa, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
            // Uh-oh, an error occurred!
            return
            }
            
            // Metadata contains file metadata such as size, content-type.
            let size = metadata.size
            // You can also access to download URL after upload.
            riversRef.downloadURL { (url, error) in
            guard let downloadURL = url else {
               
            return
                      }
           
                self.createStopMessage(msg: self.createMessage)
                  }
             
              }

            
            } else {
                /* 회원정보가 올바르지 않을 경우 알람창 호출 */
                self.createMessage = "이미있는 계정이거나 입력하신 정보가 올바르지 않습니다."
                self.createTrue = false
                self.createStopMessage(msg: self.createMessage)
            }
        }
    }
    
    /* 회원가입 클릭시 성공 or 실패를 알려주는 함수 */
    func createStopMessage(msg: String){
        let alert = UIAlertController(title: "", message: msg, preferredStyle: .alert)
                               alert.addAction(UIAlertAction(title: "확인", style: .default){
                               UIAlertAction in
                                  if self.createTrue {
                                
                                    self.dismiss(animated: true, completion: nil)
                                }
                         })
                        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func ImgUpload(_ sender: Any) {
        let alert =  UIAlertController(title: "타이뜰", message: "원하는 메세지", preferredStyle: .actionSheet)
                let library =  UIAlertAction(title: "사진앨범", style: .default) { (action) in self.openLibrary()
                }
                let camera =  UIAlertAction(title: "카메라", style: .default) { (action) in
                    self.openCamera()
                
                }
                let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
                alert.addAction(library)
                alert.addAction(camera)
                alert.addAction(cancel)
                present(alert, animated: true, completion: nil)
    }
    
      func openLibrary()
      {
          picker.sourceType = .photoLibrary
          present(picker, animated: true, completion: nil)

      }
      func openCamera()
      {
          if(UIImagePickerController .isSourceTypeAvailable(.camera)){
              picker.sourceType = .camera
            
           
              present(picker, animated: false, completion: nil)
          }
          else{
              print("Camera not available")
          }
      }
    
    @objc private func buttonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        }

    
}


extension SingInViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            profileIMG.image = image
            print("log[이미지 값 확인]: \(image)")
            profileIMG.layer.cornerRadius = profileIMG.frame.height/2
           }
        dismiss(animated: true, completion: nil)

    }
}
