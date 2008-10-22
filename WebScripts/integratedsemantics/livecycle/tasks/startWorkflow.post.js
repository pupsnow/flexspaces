
var nodeId = args.nodeid;

var node = search.findNode("workspace://SpacesStore/" + nodeId);

if (node != null)
{
    var assigner = args.assigner;

    var reviewer = args.reviewer;

    var description = args.desc;

    var workflow = actions.create("process-action");
    
    workflow.parameters["assigner-id"] = person.properties.userName;

    workflow.parameters["reviewer-id"] = reviewer;

    workflow.parameters["review-desc"] = description;

    workflow.execute(node);
    
    model.assigner = workflow.parameters["assigner-id"];    
    model.reviewer = workflow.parameters["reviewer-id"];
    model.desc = workflow.parameters["review-desc"];
}