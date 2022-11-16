//*************   © Copyrighted by Thinkcreative_Technologies. An Exclusive item of Envato market. Make sure you have purchased a Regular License OR Extended license for the Source Code from Envato to use this product. See the License Definition attached with source code. *********************

class Numberlimits {
  static int adminusername = 15;
  static int adminpin = 6;
  static int adminfullname = 25;
  static int adminpassword = 15;
  static int userfullname = 25;
  //--
  static DateTime defaultvalidtilltime = DateTime(3999, 01, 01);
  static int totalDatatoLoadAtOnceFromFirestore = 14;
  static int maxcurrencydigits = 9;
  static int maxcategoryiddigits = 3;
  static int maxproductiddigits = 17;
  static int maxsubcategoryiddigits = 4;
  static double maskopacity = 0.6;
  static double defaultclipradius = 6.0;
  static int maxtitledigits = 90;
  static int maxuiddigits = 90;
  // static int maxuseriddigits = 6;
  static int maxcategorydescdigits = 90;
  static int maxcategorydigits = 40;
  static int maxnamedigits = 40;
  static int maxcategorytaglinedigits = 25;
  static int maxsubcategorydigits = 25;
  static int maxaddressdigits = 100;
  static int maxphonedigits = 15;
  static int maxemaildigits = 40;
  static int maxurldigits = 500;
  static int maxdescdigits = 1500;
  static int maxanydigits = 10;
  static int maxcoupondigits = 10;
  static int maxorderiddigits = 12;
  static int mincoupondigits = 3;
  static int maxsubtitledigits = 370;
  static int maxparagraphdigits = 1000;
  static int imageCompressQuality = 100;
  static int maxproductgalleryphotos = 9;
  static int maxproducscreenshots = 16;
  static int imageCompressRotationAngle = 0;
  static int maxVideoFileUpload =
      50; // in MB ----This value can be overide by anywidget having specific max upload size
  static int maxPDFFileUpload =
      5; // in MB ----This value can be overide by anywidget having specific max upload size
  static int maxImageFileUpload =
      50; // in MB ----This value can be overide by anywidget having specific max upload size
  static int maxZIPFileUpload =
      500; // in MB ----This value can be overide by anywidget having specific max upload size
  static int maxDocFilesize =
      100; // in MB ----This value can be overide by anywidget having specific max upload size
  static int maxNoMultiselectfile = 10;
  static String maxFileSizeExceededError1 =
      'Sorry! File size for upload should be less than:';
  static String maxFileSizeExceededError2 =
      'Please Compress the file & Try again.';

  static int totaltxnXns =
      200; // total transactions recordes for safety. After this number, old will get automatically deleted
  static int totalhistorystore =
      250; // total history recorder for activity. After this number, old will get automatically deleted
  static int totalhistorydeleterange =
      50; // total records delete once it exceeds the totalhistorystore

  static const int totalnotificationstore =
      250; // total notification tiles. After this number, old will get automatically deleted
  static const int totalnotificationdeleterange =
      50; // to delete notification tiles
//DEPARTMENT
  static int maxdepartmenttitlechar = 30;
  static int maxdepartmentdescchar = 500;
  static int maxTicketTitle = 35;
  static int maxTicketDesc = 200;
  static int maxOnlineDurationShowForAgent =
      10; //in minutes - automatically set agent offline after this.
  //id length restrictions:
  static int agentIDlength = 3;
  static int customerIDlength = 3;
  static int ticketIDlength = 6;
}
