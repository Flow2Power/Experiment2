import { WordInfo } from "./WordInfo";
import { util } from "@kit.ArkTS";
import { BusinessError } from '@ohos.base';
//用于加载JSON文件夹中的JSON文件的类
export class JsonFileManager {
  public GetWordsData(WordBookName:string,content:Content):WordInfo[]{
    try{
      let rawFile = getContext(content).resourceManager.getRawFileContentSync(WordBookName)
      let textDecoder = util.TextDecoder.create('utf-8', { ignoreBOM : true });
      let result = textDecoder.decodeToString(rawFile);
      let words = JSON.parse(result) as WordInfo[]
      console.info('模拟器getWordsData success and words length is '+JSON.stringify(words.length));
      return words
    }catch (err){
      let error: BusinessError = err as BusinessError;
      console.error(`模拟器Failed to get Words Data. Code:${error.code}, message:${error.message}`);
      return []
    }
  }
}
export default new JsonFileManager();