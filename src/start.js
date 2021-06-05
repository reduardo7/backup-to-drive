const cron = require('node-cron');
const {
  CRON_CONFIG,
  FILE_PATH,
  GOOGLE_CLIENT_EMAIL,
  GOOGLE_PRIVATE_KEY,
} = require('./config.js');
const uploadDbDump = require('./index.js');

function exec() {
  const credentials = {
    client_email: GOOGLE_CLIENT_EMAIL,
    private_key: GOOGLE_PRIVATE_KEY,
  };

  uploadDbDump(FILE_PATH, DRIVE_FOLDER_ID, credentials, RETRY_ON_ERROR);
}

if (CRON_CONFIG) {
  cron.schedule(CRON_CONFIG, exec);
} else {
  exec();
}
