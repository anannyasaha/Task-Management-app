When starting app, you will see a top tab bar of reminders and events.
	-Reminders: (implemented) are for things you will do within the day shortly and only need a text prompt
		-to use reminders, write something in the textfield and then set a time type (seconds, mins, hour) and then
		 a time value and wait for the time to count down and your notification to appear. After is appears, click on it
		 and you will see a text box come up acknowledging you have clicked/dismissed the notification. Click anywhere else
                 on the screen to continue past the textbox
	-Events: (not yet finished) will be for things that you intend to plan for past the current day. Will include details such
		 as time, location, links, text details...

On the bottom tab bar is the too do list and the alarm
	-Task list: (implemented) there is a description of the task and date and time for that task to finish and there is a priority option and then it can assign task to other people.It sends the task details to the person via email to whom it is assigned.The tasks are stored in local storage.It has snackbar when a task is added.There is a datepicker and time picker for the every task.If the task is 4 days old it goes to the old task list. The drawer shows today task tomorrow task and assigned task.Assigned task uses the datatable.The datatable has the due date name and incharge name and the description of work.There is a delete button it deletes the task for ever.It doesnt add in the old task list.
	-Speech to text: it recognises the voice of the user througha physical device. And the speech can be saved,edited,deleted through sqflite.There is snackbar when the text is added.The texts are added in gridview and each grid is clickable and you can edit the texts or delete the text.added text can be as long as you want.
	
Contributions:
 - Firebase and Cloud Storage (Martin Truong)
 +Task manager
 +speech to text. (Anannya Saha)
 -Notifications(Michael)
