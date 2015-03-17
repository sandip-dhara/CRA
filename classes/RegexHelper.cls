/**
 * Helper class which converts a plain word into a regex string
 * for processing blacklist filters, because, let's face it, most normal humans
 * don't know how to write regex. :)
 * Author: Quinton Wall - qwall@salesforce.com
 */
public class RegexHelper
{

    public static String toRegex(String s, boolean matchWholeWords)
    {
        String wholeWordBoundary = '';
        
        if(matchWholeWords)
            wholeWordBoundary = '\\b';
            
        String regex = wholeWordBoundary+'(';
        
        List<String> chars = s.split('',0);
        
        //start at 1 to skip initial blank entry
        for(Integer i = 1; i < chars.size(); i++)
        {
           if(chars[i] == ' ') //1.6 add support for multiple words
                regex += '[ ]';
            else
                regex += '['+chars[i].toLowerCase()+'|'+chars[i].toUpperCase()+']';
        }
        
        return regex + ')'+wholeWordBoundary;
    }
}