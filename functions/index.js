const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();
const db = admin.firestore();

exports.generateSearchParams = functions.https.onRequest(async (req, res) => {
    // Introduce the 5 second delay using await
    await new Promise(resolve => setTimeout(resolve, 5000));
    const { docId, collectionName, type } = req.body;

     console.log('Received docId:', docId);
     console.log('Received collectionName:', collectionName);

    if (!docId || !collectionName) {
        throw new functions.https.HttpsError('invalid-argument', 'The function must be called with a valid docId.');
    }

    try {
        const docRef = db.collection(collectionName).doc(docId);
        const doc = await docRef.get();

        if (!doc.exists) {
            throw new Error('not-found', 'No document found with the given docId.');
        }

             // Check for existence of translatedTitles data based on type
    let translatedTitles;
    if (type === 'es') {
      translatedTitles = doc.data().translatedTitle.es;
    } else if (type === 'en') {
      translatedTitles = doc.data().translatedTitle.en;
    } else {
      // Handle invalid or unsupported type
      throw new Error('invalid-argument', 'Invalid type provided.');
    }

    if (!translatedTitles) {
      throw new Error('invalid-argument', 'No translated title data found for the provided type.');
    }

    const title = translatedTitles;
        const params = generateSubstrings(title);

        await docRef.update({ searchTranslatedParam: params });

        return { success: true, params };
    } catch (error) {
        console.error('Error generating search params:', error);
        //throw new Error('unknown', 'An error occurred while generating search params.');
        res.status(500).send("Error generating search params:");
    }
});

function generateSubstrings(str) {
    const substrings = new Set();
    const n = str.length;
    for (let i = 0; i < n; i++) {
        for (let j = i + 1; j <= n; j++) {
            substrings.add(str.slice(i, j));
        }
    }
    return Array.from(substrings);
}
