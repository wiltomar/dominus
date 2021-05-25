import { Column, PrimaryGeneratedColumn, CreateDateColumn, UpdateDateColumn, BeforeInsert, BeforeUpdate, BaseEntity } from 'typeorm';

abstract class Base {
  @PrimaryGeneratedColumn('uuid')
  uuid: string;

  @CreateDateColumn()
  createdat: Date;

  @UpdateDateColumn()
  updatedat: Date;

  @Column('tymestamp with timezone')
  deletedat: Date;
  
  @Column({ default: true })
  status: boolean;
  
  @BeforeInsert()
  setCreatedat(): void {
    this.createdat = new Date();
  }

  @BeforeUpdate()
  setUpdatedat(): void {
    this.updatedat = new Date();
  }
}

export default Base;