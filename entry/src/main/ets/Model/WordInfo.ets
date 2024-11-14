// wordInterfaces.ts

export interface Sentence {
  sContent: string;
  sContent_eng: string;
  sSpeech: string;
  sCn: string;
}

export interface SourceInfo {
  paper: string;
  level: string;
  year: string;
  type: string;
}

export interface RealExamSentence {
  sentences: SentenceWithSourceInfo[];
  desc: string;
}

export interface SentenceWithSourceInfo {
  sContent: string;
  sourceInfo: SourceInfo;
}

export interface Synonym {
  pos: string;
  tran: string;
  hwds: Hwd[];
}

export interface Hwd {
  w: string;
}

export interface RelatedWord {
  pos: string;
  words: RelatedWordItem[];
}

export interface RelatedWordItem {
  hwd: string;
  tran: string;
}

export interface WordContent {
  sentence: SentenceGroup;
  realExamSentence: RealExamSentence;
  usphone: string;
  syno: SynoGroup;
  ukphone: string;
  ukspeech: string;
  star: number;
  phone: string;
  speech: string;
  relWord: RelWordGroup;
  usspeech: string;
  trans: Trans[];
}

export interface SentenceGroup {
  sentences: Sentence[];
  desc: string;
}

export interface SynoGroup {
  synos: Synonym[];
  desc: string;
}

export interface RelWordGroup {
  rels: RelatedWord[];
  desc: string;
}

export interface Trans {
  tranCn: string;
  descCn: string;
  pos: string;
}

export interface Word {
  wordHead: string;
  wordId: string;
  content: WordContent;
}

export interface Content {
  word: Word;
}

export interface WordInfo {
  wordRank: number;
  headWord: string;
  content: Content;
  bookId: string;
}

