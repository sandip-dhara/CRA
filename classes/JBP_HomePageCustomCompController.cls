/**********************************************************
* Class Name: JBP_HomePageCustomCompController
* Author:  HP
* Date: 10-APRIL-2013
* Requirement # Request Id: 5373
* Description: This is a global class. This class returns the custom label. This class is needed as we cannot retrieve custom
                Labels directly in the home page component using the GLobal variables.
**********************************************************/

global class JBP_HomePageCustomCompController{
    
    /* 
    *  @description: This is a webservice method. This is being called fromthe homepage component from the javascript
                     using the sforce.apex.execute methods.
    *  @Params: void
    *  @return: string
    */
    webservice static string actionCustomLabel(){
        return system.label.Actions_SI;
    }
}