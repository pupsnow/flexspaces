
var taskId = null;
var task = null;

var version = server.version;
var versionNum = parseFloat(version);

// pre 2.9 doesn't seem to have workflow workflow mgr global var defined in javascript, only in freemarker

if (versionNum >= 2.9)
{
   if (args.taskid != "undefined")
   {
      taskId = args.taskid;
      task = workflow.getTaskById(taskId);
   }

   var transitionId = (args.transid == "undefined") ? "" : args.transid;

   if (task != null)
   {
      task.endTask(transitionId);
   }
}