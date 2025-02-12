แอปพลิเคชันนี้เป็นตัวอย่างการสร้างระบบยืนยันตัวตน (Authentication) ด้วย Firebase ใน Flutter ซึ่งประกอบไปด้วยหน้าต่างๆ ดังนี้:

-   หน้าหลัก (Home Page)
-   หน้าเข้าสู่ระบบ (Login Page)
-   หน้าสร้างบัญชี (Create Account Page)
-   หน้าลืมรหัสผ่าน (Forgot Password Page)

```
*   **`lib/`**: โฟลเดอร์นี้เก็บ source code หลักของแอปพลิเคชัน
    *   **`main.dart`**:  ไฟล์เริ่มต้นของแอป.  กำหนด routes, theme, และหน้าเริ่มต้น (HomePage).
    *   **`home.dart`**:  หน้าหลักของแอป. แสดงข้อความต้อนรับ และปุ่ม Sign Out (ถ้าผู้ใช้ login อยู่).
    *   **`login.dart`**:  หน้าเข้าสู่ระบบ. มี form สำหรับกรอก email และ password.
    *   **`create_account.dart`**:  หน้าสร้างบัญชีใหม่. มี form สำหรับกรอก email, password, และ confirm password.
    *   **`forgot_password.dart`**:  หน้าสำหรับรีเซ็ตรหัสผ่าน.  มี form สำหรับกรอก email.
    *   **`custom_text_field.dart`**:  (ถูกเอาออกในเวอร์ชันที่ปรับปรุงแล้ว) เคยเป็น custom widget สำหรับ input field.  ตอนนี้ถูกแทนที่ด้วย `TextFormField` ในแต่ละหน้า.
*   **`assets/`**: (ถ้ามี) โฟลเดอร์สำหรับเก็บ assets ต่างๆ เช่น รูปภาพ.
*   **`pubspec.yaml`**: ไฟล์ที่เก็บ dependencies ของโปรเจกต์ (เช่น `firebase_auth`, `firebase_core`, etc.).

## ฟังก์ชันการทำงาน

### หน้าหลัก (Home Page)

**ไฟล์:** `lib/home.dart`

**Widgets:**

*   `HomePage` (StatefulWidget):
    *   `initState()`: ตรวจสอบสถานะการล็อกอินปัจจุบันของผู้ใช้เมื่อหน้าจอถูกโหลด และตั้งค่า listener สำหรับ `authStateChanges`
    *   `_checkCurrentUser()`:  ตรวจสอบว่ามีผู้ใช้ล็อกอินอยู่หรือไม่
    *   `_signOut()`:  ออกจากระบบ (Sign Out) โดยใช้ `FirebaseAuth.instance.signOut()` และนำทางไปยังหน้า Login
    *   `build()`: สร้าง UI ของหน้าหลัก
        *   `Scaffold`: โครงสร้างหลักของหน้า
        *   `AppBar`:  แสดง title และปุ่ม Sign Out (ถ้าผู้ใช้ล็อกอินอยู่)
        *   `Container`:  ใช้ `BoxDecoration` เพื่อใส่ gradient background
        *   `Center` และ `Padding`: จัดตำแหน่ง content ให้อยู่ตรงกลาง
        *   `_buildContent()`:  แสดง content ตามสถานะการล็อกอิน (`_buildLoggedInContent` หรือ `_buildLoggedOutContent`)

*   `_buildLoggedInContent()`:  แสดง content เมื่อผู้ใช้ล็อกอินแล้ว
    *   `Icon`:  แสดง icon (เช่น `Icons.check_circle`)
    *   `Text`:  แสดงข้อความต้อนรับ พร้อมชื่อหรือ email ของผู้ใช้
    *   `ElevatedButton`:  ปุ่ม Sign Out

*   `_buildLoggedOutContent()`:  แสดง content เมื่อผู้ใช้ยังไม่ได้ล็อกอิน
    *   `Icon`: แสดงไอคอน (เช่น Icons.person)
    *   `Text`:  แสดงข้อความต้อนรับ และข้อความเชิญชวนให้ล็อกอินหรือสร้างบัญชี
    *   `ElevatedButton`:  ปุ่ม Login
    *   `OutlinedButton`:  ปุ่ม Create Account

### หน้าเข้าสู่ระบบ (Login Page)

**ไฟล์:** `lib/login.dart`

**Widgets:**

*   `LoginPage` (StatefulWidget):
    *   `_emailController`, `_passwordController`: `TextEditingController` สำหรับจัดการ input ของ email และ password
    *   `_formKey`: `GlobalKey<FormState>` สำหรับจัดการ Form
    *   `dispose()`:  Dispose `TextEditingController` เพื่อป้องกัน memory leaks
    *   `build()`: สร้าง UI ของหน้า Login
        *   `Scaffold`, `AppBar`, `Container`, `SafeArea`, `SingleChildScrollView`, `ConstrainedBox`, `Padding`, `Form`, `Column`: จัดโครงสร้างและ layout ของหน้า
        *   `Text`:  แสดง title "Welcome Back!"
        *   `TextFormField` (2 instances):  สำหรับ email และ password.  ใช้ `InputDecoration` สำหรับ styling และ `validator` สำหรับ validation.
        *   `ElevatedButton`:  ปุ่ม Login.  เมื่อกด จะเรียก `_formKey.currentState!.validate()` เพื่อ validate form และเรียก `_login()` ถ้า valid.
        *   `TextButton` (2 instances):  สำหรับ "Forgot Password?" และ "Don't have an account? Sign Up".
    *   `_login()`:  จัดการการเข้าสู่ระบบ
        1.  ดึงค่า email และ password จาก `TextEditingController`.
        2.  แสดง `CircularProgressIndicator` (loading indicator).
        3.  เรียก `FirebaseAuth.instance.signInWithEmailAndPassword()`.
        4.  ซ่อน loading indicator.
        5.  ถ้าสำเร็จ นำทางไปยังหน้า Home.
        6.  ถ้าเกิด error (เช่น `FirebaseAuthException`) แสดง error message ด้วย `_showErrorDialog()`.
    *   `_showErrorDialog()`:  แสดง `AlertDialog` พร้อม error message.

### หน้าสร้างบัญชี (Create Account Page)

**ไฟล์:** `lib/create_account.dart`

**Widgets:**

*   `CreateAccountPage` (StatefulWidget):
    *    `_emailController`, `_passwordController`, `_confirmPasswordController`: `TextEditingController` สำหรับ email, password, และ confirm password.
    *   `_formKey`: `GlobalKey<FormState>` สำหรับจัดการ Form.
    *    `dispose()`:  Dispose `TextEditingController`
    *   `build()`: สร้าง UI ของหน้า Create Account
        *   `Scaffold`, `AppBar`, `Container`, `SafeArea`, `SingleChildScrollView`, `ConstrainedBox`, `Padding`, `Form`, `Column`: จัดโครงสร้างและ layout.
        *   `Text`: แสดง title "Create Your Account".
        *   `TextFormField` (3 instances): สำหรับ email, password, และ confirm password.  ใช้ `InputDecoration` และ `validator`.
        *   `ElevatedButton`:  ปุ่ม Create Account.  เมื่อกด จะ validate form และเรียก `_createAccount()` ถ้า valid.
        *   `TextButton`: สำหรับ "Already have an account? Sign In".
    *   `_createAccount()`: จัดการการสร้างบัญชี
        1. ดึงค่า email และ password.
        2. แสดง loading indicator.
        3. เรียก `FirebaseAuth.instance.createUserWithEmailAndPassword()`.
        4. ซ่อน loading indicator.
        5. ถ้าสำเร็จ แสดง success dialog ด้วย `_showSuccessDialog()` และ navigate ไปยังหน้า Login.
        6. ถ้าเกิด error แสดง error message ด้วย `_showErrorDialog()`.
    *   `_showErrorDialog()`: แสดง `AlertDialog` พร้อม error message.
     *    `_showSuccessDialog()`: แสดง `AlertDialog` พร้อม success message.

### หน้าลืมรหัสผ่าน (Forgot Password Page)

**ไฟล์:** `lib/forgot_password.dart`

**Widgets:**

*   `ForgotPasswordPage` (StatefulWidget):
    *   `_emailController`: `TextEditingController` สำหรับ email.
    *   `_formKey`: `GlobalKey<FormState>`.
    *   `dispose()`: Dispose `_emailController`.
    *   `build()`: สร้าง UI ของหน้า Forgot Password
        *    `Scaffold`, `AppBar`, `Container`, `SafeArea`, `SingleChildScrollView`, `ConstrainedBox`, `Padding`, `Form`, `Column`: จัดโครงสร้างและ layout.
        *   `Text`: แสดง title "Reset Password" และคำอธิบาย.
        *   `TextFormField`: สำหรับ email. ใช้ `InputDecoration` และ `validator`.
        *   `ElevatedButton`:  ปุ่ม Send Reset Link.  เมื่อกด จะ validate form และเรียก `_resetPassword()` ถ้า valid.
    *   `_resetPassword()`:  จัดการการส่ง email รีเซ็ตรหัสผ่าน
        1.  ดึงค่า email.
        2.  แสดง loading indicator.
        3.  เรียก `FirebaseAuth.instance.sendPasswordResetEmail()`.
        4.  ซ่อน loading indicator.
        5.  ถ้าสำเร็จ แสดง success dialog ด้วย `_showSuccessDialog()` และ navigate กลับไปหน้า Login.
        6.  ถ้าเกิด error แสดง error message ด้วย `_showErrorDialog()`.
    *    `_showErrorDialog()`: แสดง `AlertDialog` พร้อม error message.
    *   `_showSuccessDialog()`: แสดง `AlertDialog` พร้อม success message.
