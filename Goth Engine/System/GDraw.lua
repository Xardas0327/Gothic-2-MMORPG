GDraw = {};
GDraw.__index = GDraw;

function GDraw.new(x,y,message,font,r,g,b)
	local self = setmetatable({}, GDraw);
	self.x=x;
	self.y=y;
	self.message=message;
	self.font=font;
	self.r=r;
	self.g=g;
	self.b=b;
	self.id=CreateDraw(x,y,message,font,r,g,b);
	return self;
end

function GDraw.id(self)
	return self.id;
end

function GDraw.update(self,x,y,message,font,r,g,b)
	self.x=x;
	self.y=y;
	self.message=message;
	self.font=font;
	self.r=r;
	self.g=g;
	self.b=b;
	UpdateDraw(self.id,x,y,message,font,r,g,b);
end

function GDraw.message(self,message)
	self.message=message;
	UpdateDraw(self.id,self.x,self.y,self.message,self.font,self.r,self.g,self.b);
end

function GDraw.color(self,r,g,b)
	self.r=r;
	self.g=g;
	self.b=b;
	UpdateDraw(self.id,self.x,self.y,self.message,self.font,self.r,self.g,self.b);
end

function GDraw.message_color(self,message,r,g,b)
	self.message=message;
	self.r=r;
	self.g=g;
	self.b=b;
	UpdateDraw(self.id,self.x,self.y,self.message,self.font,self.r,self.g,self.b);
end