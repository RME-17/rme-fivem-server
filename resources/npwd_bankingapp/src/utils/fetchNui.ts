import { isEnvBrowser } from './misc';

const RESOURCE_NAME = 'npwd_bankingapp';

async function fetchNui<T = any, D = any>(eventName: string, data?: D, mockResp?: T): Promise<T> {
  const options = {
    method: 'post',
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: JSON.stringify(data),
  };

  if (isEnvBrowser() && mockResp) {
    return mockResp;
  }

  const resp = await fetch(`https://${RESOURCE_NAME}/${eventName}`, options);

  const responseObj = await resp.json();

  return responseObj;
}

export default fetchNui;
