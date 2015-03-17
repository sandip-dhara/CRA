/*
Created by: Venkatesh S
Created on: 15/04/2013
Comments  : Controller for Component DGPursuitResourcesComponent to show Pursuit Resources as a table in Deal Goverance Email Notification
*/
public class DGHideEmailTextController {

public string AppId{get;set;}
public string RecpId{get;set;}


Public boolean getShowtext()
    {
    boolean bShowtext;
    for(ProcessInstanceWorkitem Workitem:[Select p.ActorId From ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId = :AppId and processInstance.status = 'Pending'])
        {
        If(Workitem.ActorId == RecpId)
            {
            bShowtext = true;
            }
        else
            {
            bShowtext = false;
            }
        }
    return bShowtext;
    }
}