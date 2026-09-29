const { onDocumentCreated } = require("firebase-functions/v2/firestore");
const admin = require("firebase-admin");

admin.initializeApp();

// -------------------------------------------------------------------------
// sendMailNotification - pushes "{sender} sent you a mail" to the recipient
// -------------------------------------------------------------------------
exports.sendMailNotification = onDocumentCreated("Mails/{mailId}", async (event) => {
  const mail = event.data.data();
  if (!mail) {
	 console.log("New mail data is empty.");
	 return;
  }

  const { title, createdBy, createdFor } = mail;

  try {
	 const [senderDoc, recipientDoc] = await Promise.all([
		admin.firestore().collection("Users").doc(createdBy).get(),
		admin.firestore().collection("Users").doc(createdFor).get()
	 ]);

	 if (!recipientDoc.exists) {
		console.log(`Recipient ${createdFor} not found in Users collection.`);
		return;
	 }

	 const fcmToken = recipientDoc.data().fcmToken;
	 if (!fcmToken) {
		console.log(`User ${createdFor} does not have an active fcmToken.`);
		return;
	 }

	 const senderName = senderDoc.exists ? senderDoc.data().displayName : "Someone";

	 const payload = {
		token: fcmToken,
		notification: {
		  title: `${senderName} sent you a mail`,
		  body: title || ""
		},
		data: {
		  mailId: event.params.mailId
		},
		apns: {
		  payload: {
			 aps: {
				sound: "default"
			 }
		  }
		}
	 };

	 const response = await admin.messaging().send(payload);
	 console.log("Mail notification sent:", response);
  } catch (error) {
	 console.error("Failed to send mail notification:", error);
  }
});
