// Hàm này sẽ đọc file txt trên Google Drive và tạo Google Form từ nội dung của file
function createFormFromDoc () {
  // Đặt ID của file txt vào biến fileId
  //var fileId = "1APNSjpjFDa90xd0-i_tnfhCmWds5XI-S9fdHGGn6zlg";
  var field = "1dGN0NppodvLJ3UaeYyM8yYw2MQ11R1PuHV1RAbjF4XE";
  //var field = "16HltDl3PpkESGmMzOp6jO8abdVRDciAYIzqfT9NfG6o";
  // Đặt tên của Google Form mới vào biến formName
  var formName = "ExampleMCQ_001_IT1110";
  var doc = DocumentApp.openById(field);
  var body = doc.getBody();
  var content = body.getText();
  // Tách nội dung của file txt thành các dòng
  var lines = content.split ('\n');

  Logger.log (lines.length);
  // Kiểm tra xem có file Google Form nào có tên giống như formName hay không
  var files = DriveApp.getFilesByName (formName);
  // Nếu có, đưa file cũ vào thùng rác
  while (files.hasNext ()) {
    var file = files.next ();
    file.setTrashed (true);
  }
  // Tạo một Google Form mới với tên formName
  var form = FormApp.create (formName);
  form.setDescription('Bài thi môn Tin học đại cương - IT1110');
  //Set quizz is true
  form.setIsQuiz(true);
  //Set progressbar is available:
  form.setProgressBar(true);
  // Set require login to false.
  form.setRequireLogin(false);
  
  var j = 1;
  //var section = form.addSectionHeaderItem();
  //section.setTitle("Phần 1");
  //section.setHelpText("Mỗi phần 50 câu");
  // Duyệt qua các dòng của file txt
  for (var i = 0; i < lines.length; i++) {

    // Lấy dòng hiện tại
    var line = lines [i];
    // Nếu dòng bắt đầu bằng ký tự Q, đó là một câu hỏi
    if (line.startsWith ("Q")) {
      // Tách dòng thành hai phần: phần trước dấu hai chấm là số thứ tự của câu hỏi, phần sau dấu hai chấm là nội dung của câu hỏi
      var question = line;
      //Logger.log(question);
      j++;
      if(j % 50 == 0)
      {
        form.addPageBreakItem();
        //tao section moi
        //Logger.log("Secttion moi " + j);
        //var section = form.addSectionHeaderItem();//.setTitle("Phần " + ((j / 50) + 1));
        //section.setTitle("Phần " + ((j / 50) + 1));
        
      }
      // Tạo một câu hỏi mới trong Google Form với nội dung là question
      var item = form.addMultipleChoiceItem ();
      item.setTitle (question);
      
      
      // Tạo một mảng để lưu các đáp án
      var choices = [];
      // Tăng biến i lên 1 để lấy dòng tiếp theo
      i++;
      // Lấy dòng tiếp theo
      var line = lines [i];
      while(line.length == 0){
        i++;
        line = lines[i];
      }
      //Logger.log(line);
      // Trong khi dòng bắt đầu bằng ký tự A, đó là một đáp án
      while (line != undefined && (line.startsWith ("A. ") || line.startsWith("B. ") 
              || line.startsWith("C. ") 
              || line.startsWith("D. ") 
              || line.startsWith("E. ") 
              || line.startsWith("F. ") 
              || line.startsWith("G. "))
              ) {
        // Tách dòng thành hai phần: phần trước dấu chấm là ký hiệu của đáp án, phần sau dấu hai chấm là nội dung của đáp án
        var parts = line.split (". ");
        // Lấy nội dung của đáp án
        var answer = parts [1];
        // Kiểm tra xem đáp án có bắt đầu bằng ký tự * hay không, nếu có thì đó là đáp án đúng 
        //A. đây là đáp án đúng. 
        //B. đây là đáp án sai
        //C. đây là đáp án cũng sai
        //D. đây cũng là đáp án sai
        //ANSWER: A
        var correct = answer.startsWith ("*");
        // Nếu đáp án bắt đầu bằng ký tự *, bỏ ký tự đó đi
        if (correct) {
          answer = answer.substring (1);
        }
        // Thêm đáp án vào mảng choices với thuộc tính correct là true hoặc false
        choices.push (item.createChoice (answer, correct));
        // Tăng biến i lên 1 để lấy dòng tiếp theo
        i++;
        // Lấy dòng tiếp theo
        var line = lines [i];
        while(!line && line != undefined && line.length == 0 && i < lines.length){
          i++;
          line = lines[i];
        }
      }
      // Gán các đáp án cho câu hỏi
      if(choices.length > 0){
        item.setChoices (choices);
        item.setRequired(true);
        item.setPoints(1);
      }
      
      if(i == lines.length - 1)
        break;
      // Giảm biến i xuống 1 để không bỏ qua dòng hiện tại
      i--;
    }
  }

  form.setShuffleQuestions(true);
  // Set response destination to email.
  //form.setDestination(FormApp.DestinationType.EMAIL, Session.getActiveUser().getEmail());
  // Set allow response edit to true.
  //form.setAllowResponseEdits(true);
  // In ra URL của Google Form mới
  Logger.log (form.getPublishedUrl ());
}
