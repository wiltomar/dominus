declare namespace Express {
  export interface Request {
    uuid: uuid;
  }

  export interface Response {
    uuid: uuid;
  }
}