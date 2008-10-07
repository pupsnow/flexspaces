
var nodeId = args.nodeid;

var node = search.findNode("workspace://SpacesStore/" + nodeId);

if (node != null)
{
    var workflowType = "jbpm$wf:" + args.type;

    var assignTo = people.getPerson(args.assignto);

    var description = args.desc;

    var workflow = actions.create("start-workflow");

    workflow.parameters.workflowName = workflowType;

    workflow.parameters["bpm:workflowDescription"] = description;

    workflow.parameters["bpm:assignee"] = assignTo;

    if ((args.duedate) && (args.duedate != ""))
    {
       var dueDate = new Date(args.duedate);
       workflow.parameters["bpm:workflowDueDate"] = dueDate;
    } 

    workflow.execute(node);
}