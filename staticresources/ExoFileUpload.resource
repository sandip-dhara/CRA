// Variable to store your files
var files;
var folderName='';
var fileName='';
//var docUrl = 'https://it-services-gw-itg.external.hp.com/gw/hpit/llba/exo/document/preview/collaboration/SLP_REPO/';
 
// Grab the files and set them to our variable
function prepareUpload(event)
{
  files = event.target.files;
}

$(document).ready(function(){

      
// Add events
$('input[type=file]').on('change', prepareUpload);


$('#MyForm').submit(function(e)
{
debugger;
$('#dvLoading').css('display','block');
$('#dvLoading').show();

//folderName=$('#txtFolderName').val();
//fileName=$('[id$=UploadFile]').val();
if($('[id$=hdnPendingFileUploadTopicId]').val()!='')
{
folderName=$('[id$=hdnPendingFileUploadTopicId]').val();
fileName=$($('[id$=UploadFile]')[1]).val();
}
else
{
folderName= $('#hdnTopicId').val();
fileName=$($('[id$=UploadFile]')[2]).val();
}

var extension=fileName.substring(fileName.lastIndexOf('\.')+1,fileName.length);
fileName=fileName.substring(fileName.lastIndexOf('\\')+1,fileName.length);
extension=extension.toUpperCase();

var exoCMSUrl=$('[id$=hdnExoCMSUrl]').val();
var randomNumber=Math.random().toString().substring(2);
var type=$('#hdnType').val();
var id=$('[id$=hdnId]').val();
var name=$('[id$=hdnName]').val();

$('#dvMessage').hide();
$('#dvErrorMessage').hide();


//if(folderName=='')
//{
//$('#dvErrorMessage').html('Please Enter the folder name');
//         $('#dvErrorMessage').css('display','block');
//         $('#dvErrorMessage').show();
//         return false;
//}

if(fileName=="")
{

$('#dvLoading').css('display','none');
$('#dvLoading').hide();
$('#dvErrorMessage').html('Please Choose a File To Upload');
         $('#dvErrorMessage').css('display','block');
         $('#dvErrorMessage').show();
         return false;
}


if(extension!='TXT' && extension!='PDF' && extension!='DOC' && extension!='DOCX' && extension!='PPT' && extension!='PPTX' && extension!='XLS' && extension!='XLSX')
{

$('#dvLoading').css('display','none');
$('#dvLoading').hide();
$('#dvErrorMessage').html('Please upload a valid file type');
         $('#dvErrorMessage').css('display','block');
         $('#dvErrorMessage').show();
         return false;
}

$('#dvLoading').css('display','block');
$('#dvLoading').show();

var data = new FormData();
    $.each(files, function(key, value)
    {
        data.append(key, value);
    });
    
    debugger;


$.ajax({
 url: exoCMSUrl+'/document/upload?communityId='+id+'&communityName='+name+'&type='+type+'&topicId='+folderName+'&category=',
        contentType:false,
        data: data,
        cache: false,
        //dataType: 'text/xml',
        crossDomain: true,
        processData: false, 
	type:'Post',       
        xhrFields: {
           withCredentials: true
        },
        success: function(data, textStatus, jqXHR) { 
       debugger;

	var url=exoCMSUrl+'/document/download?communityId='+id+'&topicId='+folderName+'&category=&fileName='+fileName;
	url=url.replace(/ /g,"%20");
    	url=url.replace(/&amp;/g, '');

        $('[id$=hdnUrl]').val(url);


        if($('[id$=hdnBoardId]').length)
        {
        $('[id$=hdnTopicId]').val(folderName);
        $('[id$=hdnLearningBoardId]').val($.urlParam('id'));
        }
        else
        {
        $('[id$=hdnCollateralId]').val(folderName);
        $('[id$=hdnCommId]').val($('[id$=hdnCommunityId]').val());
        }

        $('[id$=saveLink]').click();

        $('#dvErrorMessage').hide();

         $('#dvMessage').html('File Uploaded Succesfully');
         $('#dvMessage').css('display','block');
         $('#dvMessage').show();

$('#dvLoading').css('display','none');
$('#dvLoading').hide();
        },
        error:function (xhr, ajaxOptions, thrownError){ 
	$('#dvErrorMessage').html('Status: '+xhr.status+'Error: '+thrownError);
	$('#dvErrorMessage').show();
$('#dvLoading').css('display','none');
$('#dvLoading').hide();
        //alert(xhr.status);               
  //alert(thrownError);  
  }
        });
        return false;
        });
});