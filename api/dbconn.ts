import {Client} from "https://deno.land/x/postgres@v0.17.0/mod.ts";

async function fileExists(file: string): Promise<boolean>
{
  try {
    await Deno.lstat(`${Deno.cwd()}/${file}`);
  } catch (err) {
    if (!(err instanceof Deno.errors.NotFound)) {
      throw err;
    }
    return false;
  }
  return true;
}

async function getDatabase(): Promise<Client> {
  if (await fileExists('db.json')) {
    const decoder = new TextDecoder("utf-8");
    const data = await Deno.readFile(`${Deno.cwd()}/db.json`);
    const ClientOptions = JSON.parse(decoder.decode(data));
    return new Client(ClientOptions);
  } else {
    return new Client();
  }
}

const database = await getDatabase();
await database.connect()
export default database;