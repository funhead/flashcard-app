export class Fso {
    constructor(
        public name:string,
        public path:string,
        public size:number,
        public childFolders:[Fso],
        public files:[Fso],
        public selected:boolean,
        public expanded:boolean
    ){}
}