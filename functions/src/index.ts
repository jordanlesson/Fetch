import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();

export const sendMessageNotification = functions.firestore
    .document("conversations/{conversationID}")
    .onUpdate(async (change, context) => {
        const snapshotBefore = await change.before.data();
        const snapshotAfter = await change.after.data();

        if (snapshotBefore !== undefined && snapshotAfter !== undefined) {
            if (snapshotBefore.lastMessage.timeStamp !== snapshotAfter.lastMessage.timeStamp) {

                const users = snapshotAfter.users as Array<string>;

                const sender = snapshotAfter.lastMessage.user as string;
                const receiver = users.find((userID) => userID !== sender) as string;

                const dogDoc = await db.collection("dogs").doc(receiver).get();
                if (dogDoc.exists) {
                    const dogInfo = dogDoc.data();
                    if (dogInfo !== undefined) {
                        const owner = dogInfo.owner as string;

                        await db.collection("users").doc(owner).collection("tokens").get().then((tokens) => {
                            tokens.docs.forEach((token) => {
                                const payload: admin.messaging.MessagingPayload = {
                                    notification: {
                                        body: "You received a message",
                                        clickAction: "FLUTTER_NOTIFICATION_CLICK",
                                    }
                                }
                                const deviceID = token.data().token;

                                return fcm.sendToDevice(deviceID, payload);
                            });
                        });
                    }
                }
            }
        }
    });


export const deleteConversations = functions.firestore
    .document("users/{userID}")
    .onDelete(async (snapshot, context) => {
        if (!snapshot.exists) {
            const conversationDocs = await db.collection("conversations").where("users", "array-contains", snapshot.id).get();

            conversationDocs.docs.forEach(async (conversation) => {
                await db.collection("conversations").doc(conversation.id).delete()
            });
        } 
    }); 

// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
// export const helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });
