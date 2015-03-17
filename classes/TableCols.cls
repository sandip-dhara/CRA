public class TableCols {
    public String sOne {get; set; }
    public String sTwo{get; set; }
    public String sThree{get; set; }
    public String sFour{get; set; }
    public String sFive{get; set; }
    public String sSix{get; set; }
    public String sSeven{get; set; }
    public TableCols(){}
    public TableCols(String s1, String s2){
        sOne = s1; sTwo = s2; 
    }
    public TableCols(String s1, String s2, String s3){
        sOne = s1; sTwo = s2; sThree = s3;
    }
    public TableCols(String s1, String s2, String s3, String s4){
        sOne = s1; sTwo = s2; sThree = s3; sFour = s4;
    }
    public TableCols(String s1, String s2, String s3, String s4, String s5){
        sOne = s1; sTwo = s2; sThree = s3; sFour = s4; sFive = s5;
    }
    public TableCols(String s1, String s2, String s3, String s4, String s5, String s6){
        sOne = s1; sTwo = s2; sThree = s3; sFour = s4; sFive = s5; sSix = s6;
    }
    public TableCols(String s1, String s2, String s3, String s4, String s5, String s6, String s7){
        sOne = s1; sTwo = s2; sThree = s3; sFour = s4; sFive = s5; sSix = s6; sSeven = s7;
    }
}