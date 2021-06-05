const fs = require('fs');
const mime = require('mime-types');
const { google } = require('googleapis');
const { basename } = require('path');

const drive = google.drive('v3');

/**
 * @typedef {Object} GoogleCredentials Google Credentials
 * @property {string} client_email Google Client e-Mail.
 * @property {string} private_key Google Private Key.
 */

/**
 * One minute in milliseconds.
 */
const ONE_MINUTE = 1000 * 60;

/**
 * @param {string} filePath Full file path to backup.
 * @param {string} driveFolderId Google Drive folder ID.
 * @param {GoogleCredentials} credentials Google Credentials.
 * @returns {Promise<any>}
 */
const authAndUploadFile = (filePath, driveFolderId, credentials) =>
  new Promise((resolve, reject) => {
    const auth = new google.auth.JWT(
      credentials.client_email,
      null,
      credentials.private_key,
      ['https://www.googleapis.com/auth/drive'],
      null
    );

    auth.authorize((authErr) => {
      if (authErr) {
        return reject(authErr);
      }

      drive.files.create(
        {
          auth,
          resource: {
            name: basename(filePath),
            parents: [driveFolderId],
          },
          media: {
            mimeType: mime.lookup(filePath),
            body: fs.createReadStream(filePath),
          },
          fields: 'id',
        },
        (err, file) => {
          if (err) {
            return reject(err);
          }

          console.info('backupToDrive: Uploaded dump to google drive', file);
          resolve(file);
        }
      );
    });
  });

/**
 * @param {Error} err Error.
 * @param {string} filePath Full file path to backup.
 * @param {string} driveFolderId Google Drive folder ID.
 * @param {GoogleCredentials} credentials Google Credentials.
 * @param {number} retryOnError Times to retry.
 * @returns {Promise<any>}
 */
const onError = (err, filePath, driveFolderId, credentials, retryOnError) =>
  Promise((resolve, reject) => {
    if (retryOnError) {
      retryOnError--;
      console.warn(
        `backupToDrive: Couldn't read ${filePath} file. Retrying in 1 minute...`,
        err
      );

      setTimeout(
        () =>
          backupToDrive(filePath, driveFolderId, credentials, retryOnError)
            .then(resolve)
            .catch(reject),
        ONE_MINUTE
      );
    } else {
      console.error(`backupToDrive: Fail on upload file`, err);
      reject(err);
    }
  });

/**
 * Upload your backups to Google Drive.
 *
 * @param {string} filePath Full file path to backup.
 * @param {string} driveFolderId Google Drive folder ID.
 * @param {GoogleCredentials} credentials Google Credentials.
 * @param {number} retryOnError Times to retry.
 * @returns {Promise<any>}
 */
const backupToDrive = (
  filePath,
  driveFolderId,
  credentials,
  retryOnError = 0
) =>
  new Promise((resolve, reject) => {
    try {
      // Check if latest.tgz exists
      fs.statSync(filePath);
      fs.readFileSync(filePath); // ..., { encoding: 'utf-8' }

      // In case the files exists, read the credentials and run the upload
      authAndUploadFile(filePath, driveFolderId, credentials)
        .then(resolve)
        .catch((err) =>
          onError(err, filePath, driveFolderId, credentials, retryOnError)
            .then(resolve)
            .catch(reject)
        );
    } catch (err) {
      onError(err, filePath, driveFolderId, credentials, retryOnError)
        .then(resolve)
        .catch(reject);
    }
  });

module.exports = backupToDrive;
