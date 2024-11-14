import { BusinessError } from '@ohos.base';
import dataPreferences from '@ohos.data.preferences';
export class DataPersistence{
  //定义存储对象
  private static preferences: dataPreferences.Preferences | undefined = undefined;
  //储存数组
  public static async putNumberArray(key: string, value: number[],context:Context): Promise<void> {
    try{
      DataPersistence.preferences = await dataPreferences.getPreferences(context,'DataPersistence');
      await DataPersistence.preferences.put(key,value);
      await DataPersistence.preferences.flush();
      console.info('模拟器putNumberArray success');
    }catch (err){
      let error: BusinessError = err as BusinessError;
      console.error(`模拟器Failed to put NumberArray. Code:${error.code}, message:${error.message}`);
      return;
    }
  }
  //获取数组
  public static async getNumberArray(key: string,context:Context): Promise<number[]> {
    try{
      DataPersistence.preferences = await dataPreferences.getPreferences(context,'DataPersistence');
      let result = await DataPersistence.preferences.get(key,[]) as number[];
      console.info('模拟器getNumberArray success');
      return result;
    }catch (err){
      let error: BusinessError = err as BusinessError;
      console.error(`模拟器Failed to get NumberArray. Code:${error.code}, message:${error.message}`);
      return [];
    }
  }
  //储存英语书名
  public static async putWordBookName(value: string,context:Context): Promise<void> {
    try{
      DataPersistence.preferences = await dataPreferences.getPreferences(context,'DataPersistence');
      await DataPersistence.preferences.put('WordBookName',value);
      await DataPersistence.preferences.flush();
      console.info('模拟器putWordBookName success');
    }catch (err){
      let error: BusinessError = err as BusinessError;
      console.error(`模拟器Failed to put WordBookName. Code:${error.code}, message:${error.message}`);
      return;
    }
  }
  //获取英语书名
  public static async getWordBookName(context:Context): Promise<string> {
    try{
      DataPersistence.preferences = await dataPreferences.getPreferences(context,'DataPersistence');
      let result = await DataPersistence.preferences.get('WordBookName','CET4') as string;
      console.info('模拟器getWordBookName success');
      return result;
    }catch (err){
      let error: BusinessError = err as BusinessError;
      console.error(`模拟器Failed to get WordBookName. Code:${error.code}, message:${error.message}`);
      return 'CET4';
    }
  }
  //储存总单词学习进度、拼写挑战记录、听写挑战记录
  public static async putRecord(value: string,data:number,context:Context): Promise<void> {
    try{
      DataPersistence.preferences = await dataPreferences.getPreferences(context,'DataPersistence');
      await DataPersistence.preferences.put(value,data);
      await DataPersistence.preferences.flush();
      console.info('模拟器putRecord success'+value+' '+data);
    }catch (err){
      let error: BusinessError = err as BusinessError;
      console.error(`模拟器Failed to put Record. Code:${error.code}, message:${error.message}`);
      return;
    }
  }
  //获取总单词学习进度、拼写挑战记录、听写挑战记录
  public static async getRecord(value:string,context:Context): Promise<number> {
    try{
      DataPersistence.preferences = await dataPreferences.getPreferences(context,'DataPersistence');
      let result = await DataPersistence.preferences.get(value,0) as number;
      console.info('模拟器getRecord '+value+' success'+result);
      return result;
    }catch (err){
      let error: BusinessError = err as BusinessError;
      console.error(`模拟器Failed to get Record. Code:${error.code}, message:${error.message}`);
      return 0;
    }
  }
}