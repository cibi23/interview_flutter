
import {onRequest} from "firebase-functions/v2/https";
import * as admin from "firebase-admin";
admin.initializeApp();


export const products = onRequest(async (request, response) => {
  const limit = +(request.query.limit ?? 0);
  const page = +(request.query.page ?? 0);
  const min = (page - 1) * limit;
  const db = admin.firestore();

  const snapshot = await db.collection("products")
    .orderBy("id").where("id", ">", min).limit(limit).get();
  const list = snapshot.docs.map((docs) => docs.data());

  response.status(200).send(list);
});

export const productdetails = onRequest(async (request, response) => {
  const id = +request.params[0];
  const db = admin.firestore();
  const snapshot = await db.collection("products").where("id", "==", id).get();
  const product = snapshot.docs[0].data();

  response.send(product);
});
